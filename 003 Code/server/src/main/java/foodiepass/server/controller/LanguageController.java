package foodiepass.server.controller;

import foodiepass.server.dto.response.LanguageResponse;
import foodiepass.server.exception.dto.SuccessResponse;
import foodiepass.server.service.LanguageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static foodiepass.server.exception.enums.SuccessMessage.*;


@RestController
@RequiredArgsConstructor
public class LanguageController {

    private final LanguageService languageService;

    @GetMapping("/language")
    public ResponseEntity<SuccessResponse<List<LanguageResponse>>> getLanguages() {
        final List<LanguageResponse> languageResponses = languageService.findAllLanguages();
        return ResponseEntity.ok(SuccessResponse.of(SUCCESS_LANGUAGE_FETCH, languageResponses));
    }
}
