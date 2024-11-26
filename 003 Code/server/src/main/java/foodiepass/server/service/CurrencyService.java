package foodiepass.server.service;

import foodiepass.server.domain.Currency;
import foodiepass.server.domain.CurrencyPriceConcater;
import foodiepass.server.dto.request.CalculatePriceRequest;
import foodiepass.server.dto.response.CalculatePriceResponse;
import foodiepass.server.dto.response.CurrencyResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.function.Function;

import static foodiepass.server.dto.request.CalculatePriceRequest.OrderElementRequest;

@Service
@RequiredArgsConstructor
public class CurrencyService {

    private final CurrencyPriceConcater currencyPriceConcater;

    public List<CurrencyResponse> findAllCurrencies() {
        return Arrays.stream(Currency.values())
                .map(CurrencyResponse::from)
                .toList();
    }

    public CalculatePriceResponse calculateOrdersPrice(final CalculatePriceRequest request) {
        final Currency originCurrency = Currency.fromCurrencyName(request.originCurrency());
        final Currency userCurrency = Currency.fromCurrencyName(request.userCurrency());

        final Double originTotalPrice = calculatePrice(request.orders(), OrderElementRequest::originPrice);
        final Double userTotalPrice = calculatePrice(request.orders(), OrderElementRequest::userPrice);

        return createCalculatePriceResponse(originCurrency, userCurrency, originTotalPrice, userTotalPrice);
    }

    private Double calculatePrice(
            final List<OrderElementRequest> orderElementRequests,
            final Function<OrderElementRequest, Double> priceSupplier
    ) {
        return orderElementRequests.stream()
                .mapToDouble(orderElement -> priceSupplier.apply(orderElement) * orderElement.quantity())
                .sum();
    }

    private CalculatePriceResponse createCalculatePriceResponse(
            Currency originCurrency, Currency userCurrency, Double originTotalPrice, Double userTotalPrice
    ) {
        final String originPriceWithCurrencyUnit = formatPriceWithCurrency(originCurrency, originTotalPrice);
        final String userPriceWithCurrencyUnit = formatPriceWithCurrency(userCurrency, userTotalPrice);

        return new CalculatePriceResponse(originPriceWithCurrencyUnit, userPriceWithCurrencyUnit);
    }

    private String formatPriceWithCurrency(Currency currency, Double price) {
        return currencyPriceConcater.concatPriceWithCurrency(currency.getISO4217Code(), price);
    }
}
