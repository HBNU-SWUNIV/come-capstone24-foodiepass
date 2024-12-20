package foodiepass.server.dto.response;

import foodiepass.server.domain.Language;

public class LanguageResponse {

    private final String languageName;

    private LanguageResponse() {
        this(null);
    }

    public LanguageResponse(final String languageName) {
        this.languageName = languageName;
    }

    public static LanguageResponse from(final Language language) {
        return new LanguageResponse(language.getLanguageName());
    }

    public String getLanguageName() {
        return languageName;
    }
}
