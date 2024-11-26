package foodiepass.server.service;

import foodiepass.server.domain.Language;
import foodiepass.server.dto.response.LanguageResponse;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class LanguageService {

    public List<LanguageResponse> findAllLanguages() {
        return Arrays.stream(Language.values())
                .map(LanguageResponse::from)
                .toList();
    }
}
