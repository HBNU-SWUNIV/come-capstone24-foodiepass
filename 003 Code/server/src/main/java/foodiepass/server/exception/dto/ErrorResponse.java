package foodiepass.server.exception.dto;

import lombok.Builder;

@Builder
public record ErrorResponse(
        int status,
        String message
) {
    public static ErrorResponse of(int status, String message) {
        return ErrorResponse.builder()
                .status(status)
                .message(message)
                .build();
    }

}
