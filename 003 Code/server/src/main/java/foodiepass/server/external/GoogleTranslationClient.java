package foodiepass.server.external;

import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.cloud.translate.Translate;
import com.google.cloud.translate.TranslateOptions;
import com.google.cloud.translate.Translation;
import foodiepass.server.domain.Language;
import foodiepass.server.domain.TranslationClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

@Component
@Profile("!test")
public class GoogleTranslationClient implements TranslationClient {

    private final Translate translate;

    public GoogleTranslationClient(
            @Value("${google.credential-path}") final String path
    ) {
        translate = initTranslateIfProd(path);
    }

    private Translate initTranslateIfProd(final String path) {
        try (final InputStream serviceStream = new FileInputStream(path)) {
            final ServiceAccountCredentials credential = ServiceAccountCredentials
                    .fromStream(serviceStream);

            return TranslateOptions.newBuilder()
                    .setCredentials(credential)
                    .build()
                    .getService();

        } catch (final IOException e) {
            throw new RuntimeException("Failed to initialize Google Translate client", e);
        }
    }

    public String translate(final Language source, final Language target, final String content) {
        if (source == target) {
            return content;
        }
        final Translation translation = translate.translate(
                content,
                Translate.TranslateOption.sourceLanguage(source.getISO639Code()),
                Translate.TranslateOption.targetLanguage(target.getISO639Code()),
                Translate.TranslateOption.model("base")
        );
        return translation.getTranslatedText();
    }
}
