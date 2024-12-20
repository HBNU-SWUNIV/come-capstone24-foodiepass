package foodiepass.server.domain;

import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static foodiepass.server.domain.Language.ENGLISH;
import static java.lang.System.lineSeparator;
import static java.util.stream.Collectors.joining;

@Component
public class ScriptGenerator {

    private static final String ORDER_ITEM_FORMAT = "%d %s";
    private static final String ENGLISH_SCRIPT_PREFIX = "Hello I want to order";

    private final Map<Language, String> languageScriptPrefixMap;
    private final TranslationClient translationClient;

    public ScriptGenerator(final TranslationClient translationClient) {
        this.translationClient = translationClient;
        this.languageScriptPrefixMap = new HashMap<>();
        languageScriptPrefixMap.put(ENGLISH, ENGLISH_SCRIPT_PREFIX);
    }

    private static String concatOrder(final List<OrderItem> orderItems) {
        return orderItems.stream()
                .map(orderItem -> String.format(ORDER_ITEM_FORMAT, orderItem.quantity(),
                        orderItem.userMenuName()))
                .collect(joining(lineSeparator()));
    }

    /**
     * @param sourceLanguage 주문 목록의 언어
     * @param targetLanguage 번역하고 싶은 언어
     * @param orderItems     주문 목록
     * @return sourceLanguage 형태의 스크립트 + targetLanguage 형태의 스크립트
     */
    public Script generate(
            final Language sourceLanguage, final Language targetLanguage, final List<OrderItem> orderItems
    ) {
        final String orderScriptPrefix = createOrderScriptPrefix(sourceLanguage);

        final String concatOrders = concatOrder(orderItems);

        final String userScript = orderScriptPrefix + lineSeparator() + concatOrders;
        final String travelScript = translationClient.translate(
                sourceLanguage, targetLanguage, userScript
        );

        return new Script(userScript, travelScript);
    }

    private String createOrderScriptPrefix(final Language sourceLanguage) {
        return languageScriptPrefixMap.computeIfAbsent(
                sourceLanguage,
                key -> translationClient.translate(ENGLISH, sourceLanguage, ENGLISH_SCRIPT_PREFIX)
        );
    }
}
