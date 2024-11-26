package foodiepass.server.controller;

import foodiepass.server.dto.response.CurrencyResponse;
import foodiepass.server.exception.dto.SuccessResponse;
import foodiepass.server.service.CurrencyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static foodiepass.server.exception.enums.SuccessMessage.SUCCESS_CURRENCY_FETCH;

@RestController
@RequiredArgsConstructor
public class CurrencyController {

    private final CurrencyService currencyService;

    @GetMapping("/currency")
    public ResponseEntity<SuccessResponse<List<CurrencyResponse>>> getCurrencies() {
        final List<CurrencyResponse> currencyResponses = currencyService.findAllCurrencies();
        return ResponseEntity.ok(SuccessResponse.of(SUCCESS_CURRENCY_FETCH, currencyResponses));
    }
}
