package foodiepass.server.domain;

import foodiepass.server.exception.CustomerException;
import lombok.RequiredArgsConstructor;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

import static foodiepass.server.exception.enums.ErrorMessage.CURRENCY_RATE_ELEMENT_NOT_FOUND;
import static foodiepass.server.exception.enums.ErrorMessage.CURRENCY_RATE_SCRAPING_FAILED;

@Component
@RequiredArgsConstructor
public class CurrencyConverter {

    private static final String GOOGLE_FINANCE_URL = "https://www.google.com/finance/quote/";
    private final CurrencyPriceConcater currencyPriceConcater;

    public List<PriceInfo> convert(List<Double> originPrices, String from, String to) {
        final String url = buildUrl(from, to);
        final String html = scrapHtml(url);
        final Double exchangeRate = extractExchangeRate(html);

        return originPrices.stream()
                .map(originPrice -> generatePriceInfo(from, to, originPrice, exchangeRate))
                .toList();
    }

    public String scrapHtml(String url) {
        String html = fetchHtml(url);
        if (html == null || html.isEmpty()) {
            throw new CustomerException(CURRENCY_RATE_SCRAPING_FAILED);
        }
        return html;
    }

    private PriceInfo generatePriceInfo(
            final String from, final String to, final Double originPrice, final Double exchangeRate
    ) {
        final Double userPrice = originPrice * exchangeRate;
        return new PriceInfo(
                originPrice, currencyPriceConcater.concatPriceWithCurrency(from, originPrice)
                , userPrice, currencyPriceConcater.concatPriceWithCurrency(to, userPrice)
        );
    }

    private String buildUrl(String from, String to) {
        return GOOGLE_FINANCE_URL + from + "-" + to;
    }

    private String fetchHtml(String url) {
        try {
            return Jsoup.connect(url).get().html();
        } catch (IOException e) {
            System.err.println("Failed to scrape URL: " + url + " due to: " + e.getMessage());
            return null;
        }

    }

    private Double extractExchangeRate(String html) {
        Document doc = Jsoup.parse(html);
        Element exchangeRateElement = doc.selectFirst("div[class=YMlKec fxKbKc]");

        if (exchangeRateElement == null) {
            throw new CustomerException(CURRENCY_RATE_ELEMENT_NOT_FOUND);
        }

        String exchangeRateString = exchangeRateElement.text().replaceAll(",", "");

        try {
            return Double.parseDouble(exchangeRateString);
        } catch (NumberFormatException e) {
            throw new CustomerException(CURRENCY_RATE_ELEMENT_NOT_FOUND);
        }
    }

}
