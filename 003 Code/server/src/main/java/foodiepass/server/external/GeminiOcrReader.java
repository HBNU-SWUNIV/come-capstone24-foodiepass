package foodiepass.server.external;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.PartMaker;
import com.google.protobuf.ByteString;
import foodiepass.server.domain.MenuItem;
import foodiepass.server.domain.OcrReader;
import foodiepass.server.exception.CustomerException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;

import com.google.auth.oauth2.GoogleCredentials;
import static foodiepass.server.exception.enums.ErrorMessage.*;

@Component
@Profile("!test")
public class GeminiOcrReader implements OcrReader {

    private static final String PROJECT_ID = "sc24-goodeat";
    private static final String LOCATION = "us-central1";
    private static final String MODEL_NAME = "gemini-pro-vision";
    private static final String SCOPE = "https://www.googleapis.com/auth/cloud-platform";
    public static final String JSON_EXTRACT_PROMPT_MESSAGE = "Given a menu image, please extract and print the names and prices of the food items in JSON format. Follow the structure below for each item:\n\n[{\"name\": \"Name of the Food (String)\", \"price\": Price of the Food (double)}, ...]";

    private final GoogleCredentials credentials;
    private final ObjectMapper objectMapper;

    public GeminiOcrReader(
            @Value("${google.credential.path:not prod}") final String credentialPath,
            final ObjectMapper objectMapper
    ) throws IOException {
        credentials = GoogleCredentials
                .fromStream(new ClassPathResource(credentialPath)
                        .getInputStream()).createScoped(SCOPE);
        this.objectMapper = new ObjectMapper();
    }

    @Override
    public List<MenuItem> read(final String base64encodedImage) {
        final ByteString byteStringImage = ByteString.copyFrom(
                Base64.getDecoder().decode(base64encodedImage)
        );

        final String serializedResult = runGemini(byteStringImage);

        System.out.println(serializedResult);

        return deserialize(serializedResult);
    }

    public List<MenuItem> deserialize(final String serializeStr) {
        try {
            final MenuItem[] menuItems = objectMapper.readValue(serializeStr, MenuItem[].class);
            return Arrays.stream(menuItems)
                    .toList();
        } catch (final JsonProcessingException e) {
            throw new CustomerException(OCR_RESULT_IS_NOT_JSON);
        }
    }

    private String runGemini(final ByteString byteStringImage) {
        try (final VertexAI vertexAI = new VertexAI(PROJECT_ID, LOCATION, credentials)) {
            final GenerativeModel model = new GenerativeModel(MODEL_NAME, vertexAI);

            final GenerateContentResponse response = model.generateContent(
                    ContentMaker.fromMultiModalData(
                            PartMaker.fromMimeTypeAndData("image/jpeg", byteStringImage),
                            JSON_EXTRACT_PROMPT_MESSAGE
                    ));
            final String unicodeString = response.getCandidates(0).getContent().getParts(0).getText();

            return decodeUnicode(unicodeString);
        } catch (final IOException e) {
            throw new CustomerException(OCR_READ_FAIL);
        }
    }

    private String decodeUnicode(String unicodeString) {
        final StringBuilder result = new StringBuilder();
        int index = 0;
        while (index < unicodeString.length()) {
            char c = unicodeString.charAt(index);
            if (c == '\\' && index + 1 < unicodeString.length()) {
                char nextChar = unicodeString.charAt(index + 1);
                if (nextChar == 'u' && index + 5 < unicodeString.length()) {
                    String unicode = unicodeString.substring(index + 2, index + 6);
                    int codePoint = Integer.parseInt(unicode, 16);
                    result.append((char) codePoint);
                    index += 6;
                    continue;
                }
            }
            result.append(c);
            index++;
        }

        return removeMarkDownSyntax(result.toString());
    }

    private String removeMarkDownSyntax(final String result) {
        return result
                .replaceFirst("json", "")
                .replaceFirst("JSON", "")
                .replaceAll("```", "");
    }
}
