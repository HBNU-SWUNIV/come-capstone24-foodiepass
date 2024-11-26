package foodiepass.server.service;

import foodiepass.server.domain.FoodInfo;
import foodiepass.server.repository.FoodInfoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class FoodService {

    // 음식 이미지를 찾을 수 없는 경우의 기본 이미지 URL
    private static final String FOOD_IMG_NOT_FOUND_URL = "https://storage.googleapis.com/goodeat/food_image_not_found.jpg";
    // 음식 설명을 찾을 수 없는 경우의 기본 설명
    private static final String FOOD_DES_NOT_FOUND = "해당 음식에 대한 정보를 준비 중입니다.";

    private final Map<String, FoodInfo> foodInfoCache = new ConcurrentHashMap<>();
    private final FoodInfoRepository foodInfoRepository;

    public List<FoodInfo> findFoods(final List<String> foodNames) {
        // 각 음식에 대해 정보 조회
        return foodNames.stream()
                .map(foodName -> foodInfoCache.computeIfAbsent(foodName, this::fetchFoodInfo))
                .toList();
    }

    private FoodInfo fetchFoodInfo(final String foodName) {
        // DB에서 음식 정보를 검색
        return foodInfoRepository.findByName(foodName)
                .map(entity -> new FoodInfo(
                        entity.getName(),
                        entity.getImageUrl(),
                        entity.getPreviewImageUrl(),
                        entity.getDescription()
                ))
                // 검색 실패 시 기본 정보를 반환
                .orElseGet(() -> new FoodInfo(
                        foodName, FOOD_IMG_NOT_FOUND_URL, FOOD_IMG_NOT_FOUND_URL, FOOD_DES_NOT_FOUND
                ));
    }
}
