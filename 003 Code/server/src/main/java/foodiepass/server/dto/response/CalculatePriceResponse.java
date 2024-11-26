package foodiepass.server.dto.response;

public record CalculatePriceResponse(
        String totalPriceWithOriginCurrencyUnit,
        String totalPriceWithUserCurrencyUnit
) {

}
