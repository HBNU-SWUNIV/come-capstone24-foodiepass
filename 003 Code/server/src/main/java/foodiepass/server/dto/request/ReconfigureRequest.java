package foodiepass.server.dto.request;

public record ReconfigureRequest(
        String originLanguageName,
        String userLanguageName,
        String originCurrencyName,
        String userCurrencyName,
        String base64EncodedImage
) {
}
