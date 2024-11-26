package foodiepass.server.service;

import foodiepass.server.domain.*;
import foodiepass.server.dto.request.ReconfigureRequest;
import foodiepass.server.dto.response.ReconfigureResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static foodiepass.server.domain.Language.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReconfigurationService {

    private final TranslationClient translationClient;
    private final CurrencyConverter currencyConverter;
    private final FoodService foodService;
    private final OcrReader ocrReader;

    public List<ReconfigureResponse> reconfigure(final ReconfigureRequest request) {
        final Language originLanguage = fromLanguageName(request.originLanguageName());
        final Language userLanguage = fromLanguageName(request.userLanguageName());

        final Currency originCurrency = Currency.fromCurrencyName(request.originCurrencyName());
        final Currency userCurrency = Currency.fromCurrencyName(request.userCurrencyName());

        // 메뉴 이름 추출
        log.info("ocr 시작");
        final List<MenuItem> menuItems = ocrReader.read(request.base64EncodedImage());
        final List<String> menuItemNames = menuItems.stream()
                .map(MenuItem::name)
                .toList();
        log.info("ocr 끝");

        // OCR 결과 번역
        final List<String> translatedMenuNames = menuItemNames.stream()
                .map(name -> translationClient.translate(originLanguage, userLanguage, name))
                .toList();

        // 음식 정보 조회
        final List<FoodInfo> foodInfos = foodService.findFoods(menuItemNames);

        // 번역 처리
        final List<FoodInfo> translatedFoodInfos = translateFoodInfos(foodInfos, originLanguage, userLanguage);

        // 환율 계산
        final List<PriceInfo> convertedPrices = convertCurrency(
                menuItems, originCurrency, userCurrency
        );

        final List<ReconfigureResponse> responses = new ArrayList<>();
        for (int i = 0; i < menuItems.size(); i++) {
            final ReconfigureResponse response = ReconfigureResponse.createResponse(
                    menuItemNames.get(i), // 원본 메뉴 이름
                    translatedFoodInfos.get(i),
                    translatedMenuNames.get(i), // 번역된 이름
                    convertedPrices.get(i)
            );
            responses.add(response);
        }

        return responses;
    }

    private List<FoodInfo> translateFoodInfos(
            final List<FoodInfo> foodInfos, final Language originLanguage, final Language userLanguage
    ) {
        log.info("음식 정보 번역 시작");
        return foodInfos.stream()
                .map(foodInfo -> {
                    // 원본 언어로 번역된 설명이 없으면 번역 처리
                    final String translatedDescription = translationClient.translate(
                            originLanguage, userLanguage, foodInfo.description()
                    );
                    return new FoodInfo(
                            foodInfo.name(),
                            foodInfo.image(),
                            foodInfo.previewImage(),
                            translatedDescription
                    );
                }).toList();
    }


    private List<PriceInfo> convertCurrency(
            final List<MenuItem> menuItems, final Currency originCurrency, final Currency userCurrency
    ) {
        log.info("환율계산 시작");
        final List<Double> prices = menuItems.stream()
                .map(MenuItem::price)
                .toList();
        log.info("환율계산 끝");
        return currencyConverter.convert(
                prices, originCurrency.getISO4217Code(), userCurrency.getISO4217Code()
        );
    }
}
