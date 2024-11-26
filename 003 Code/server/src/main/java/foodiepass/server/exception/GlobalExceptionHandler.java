package foodiepass.server.exception;

import foodiepass.server.exception.dto.ErrorResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomerException.class)
    public ResponseEntity<ErrorResponse> handleCustomException(CustomerException e) {
        return ResponseEntity
                .badRequest()
                .body(ErrorResponse.of(
                        e.getErrorMessage().getStatus(),
                        e.getErrorMessage().getMessage()
                ));
    }
}
