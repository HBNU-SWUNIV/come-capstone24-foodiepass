package foodiepass.server.external;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import foodiepass.server.domain.FoodInfo;
import foodiepass.server.domain.FoodScrapper;
import foodiepass.server.exception.CustomerException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

import static foodiepass.server.exception.enums.ErrorMessage.*;
import static foodiepass.server.external.TasteAtlasResponse.*;
import static org.springframework.http.HttpMethod.GET;

@Component
@Profile("!test")
public class UrlFoodScrapper implements FoodScrapper {

    private static final String TASTE_ATLAS_URL = "https://www.tasteatlas.com/";
    private static final String FOOD_IMG_NOT_FOUND_URL = "https://storage.googleapis.com/goodeat/food_image_not_found.jpg";
    private static final String FOOD_DES_NOT_FOUND = "We're preparing information about this food.";
    private static final String IMAGE_SELECTOR = "meta[property=og:image]";
    private static final String DESCRIPTION_SELECTOR = "meta[property=og:description]";
    private static final String FOOD_SEARCH_QUERY = "https://www.tasteatlas.com/api/v3/autocomplete?onlyRecipes=false&query=%s";

    private final Map<String, FoodInfo> foodInfoCache = new ConcurrentHashMap<>();
    private final RestTemplate restTemplate = new RestTemplateBuilder().build();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private String auth = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InRhX3dlYiIsImVtYWlsIjoidGFfd2ViIiwibmFtZWlkIjoiMCIsInJvbGUiOiJ0YV93ZWIiLCJBbm9ueW1vdXMiOiJ0cnVlIiwiaXNzIjoidGFzdGVhdGxhcy5jb20iLCJhdWQiOiJ0YV93ZWIiLCJleHAiOjE3MDg4MDE1MjIsIm5iZiI6MTcwODc3OTkyMn0.xcfqw10i3rGimJUIQe7plpmH5lW9ZlbqwCZj2MtbSCc";

    @Override
    public List<FoodInfo> scrap(final List<String> foodNames) {
        return foodNames.stream()
                .map(foodName -> foodInfoCache.computeIfAbsent(foodName, this::scrapFoodInfo))
                .toList();
    }

    private FoodInfo scrapFoodInfo(final String foodName) {
        try {
            return crawlFoodInfo(foodName);
        } catch (final RuntimeException exception) {
            throw new CustomerException(FOOD_INFO_SCRAP_FAILED);
        }
    }


    private FoodInfo extractFoodInfo(final String html, final Item item) {
        final Document doc = Jsoup.parse(html);
        final String foodDescription = getFoodDescription(doc);
        final String foodImageUrl = getFoodImageUrl(doc);
        final String image = Optional.ofNullable(item.getPreviewImage().getImage())
                .orElse(FOOD_IMG_NOT_FOUND_URL);
        return new FoodInfo(item.generateFullName(), foodImageUrl, image, foodDescription);
    }

    private String getFoodImageUrl(final Document document) {
        return Optional.ofNullable(document.select(IMAGE_SELECTOR).first())
                .map(metaTag -> metaTag.attr("content"))
                .orElse(FOOD_IMG_NOT_FOUND_URL);
    }

    private static String getFoodDescription(final Document document) {
        return Optional.ofNullable(document.select(DESCRIPTION_SELECTOR).first())
                .map(metaTag -> metaTag.attr("content"))
                .orElse(FOOD_DES_NOT_FOUND);
    }

    private FoodInfo crawlFoodInfo(final String foodName) {
        try {
            final Item item = search(foodName);

            final String url = TASTE_ATLAS_URL + item.getUrlLink();
            final String html = Jsoup.connect(url).get().html();

            return extractFoodInfo(html, item);
        } catch (final IOException e) {
            throw new CustomerException(FOOD_NOT_FOUND);
        }
    }

    private Item search(final String foodName) throws CustomerException {
        final ResponseEntity<String> responseEntity = searchSite(
                foodName);

        if (responseEntity.getStatusCode().is2xxSuccessful()) {
            final String body = responseEntity.getBody();
            try {
                final TasteAtlasResponse responses = objectMapper.readValue(body, TasteAtlasResponse.class);
                return responses.findFirst();
            } catch (final JsonProcessingException e) {
                throw new CustomerException(FOOD_RESULT_IS_NOT_JSON);
            }
        } else {
            throw new CustomerException(FOOD_NOT_FOUND);
        }
    }

    private ResponseEntity<String> searchSite(final String foodName) {
        final String replacedFoodName = foodName.replaceAll(" ", "+");
        final String searchQuery = String.format(FOOD_SEARCH_QUERY, replacedFoodName);

        final HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", auth);
        final HttpEntity<Object> entity = new HttpEntity<>(null, headers);

        return restTemplate.exchange(searchQuery, GET, entity, String.class);
    }

    public void updateAuth(final String auth) {
        this.auth = auth;
    }
}
