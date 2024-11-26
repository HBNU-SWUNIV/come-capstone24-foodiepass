package foodiepass.server.exception.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorMessage {

    //Currency
    CURRENCY_RATE_SCRAPING_FAILED(500, "Google Finance 페이지 크롤링에 실패했습니다."),
    CURRENCY_RATE_ELEMENT_NOT_FOUND(404, "Google Finance 페이지에서 환율 요소를 찾을 수 없습니다."),

    //Language
    LANGUAGE_NOT_FOUND(404,"언어를 찾을 수 없습니다."),

    //Reconfiguration
    FOOD_INFO_SCRAP_FAILED(500, "음식 정보를 스크랩하는 데 실패했습니다."),
    FOOD_NOT_FOUND(404, "음식을 찾을 수 없습니다."),
    FOOD_RESULT_IS_NOT_JSON(400, "응답 결과가 JSON 형식이 아닙니다."),
    OCR_RESULT_IS_NOT_JSON(400, "OCR 결과가 JSON 형식이 아닙니다."),
    OCR_READ_FAIL(500, "OCR 읽기에 실패했습니다."),
    ;


    private final int status;
    private final String message;
}
