package foodiepass.server.exception;

import foodiepass.server.exception.enums.ErrorMessage;
import lombok.Getter;

@Getter
public class CustomerException extends RuntimeException{

    private ErrorMessage errorMessage;

    public CustomerException(ErrorMessage errorMessage) {
        super(errorMessage.getMessage());
        this.errorMessage = errorMessage;
    }
}
