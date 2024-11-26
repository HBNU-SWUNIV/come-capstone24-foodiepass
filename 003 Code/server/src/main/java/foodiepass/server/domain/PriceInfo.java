package foodiepass.server.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PriceInfo {
    private Double originPrice;
    private String originPriceWithCurrencyUnit;
    private Double userPrice;
    private String userPriceWithCurrencyUnit;
}
