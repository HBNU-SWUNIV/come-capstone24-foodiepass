package foodiepass.server.exception.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum SuccessMessage {

    //Currency
    SUCCESS_CURRENCY_FETCH(200, "통화 정보를 성공적으로 조회했습니다."),

    //Language
    SUCCESS_LANGUAGE_FETCH(200, "언어 목록을 성공적으로 조회했습니다."),

    //Reconfigure
    RECONFIGURE_SUCCESS(200, "구성이 성공적으로 완료되었습니다."),
    ;

    private final int status;
    private final String message;
}
