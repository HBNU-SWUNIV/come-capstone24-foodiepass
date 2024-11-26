package foodiepass.server.service;

import foodiepass.server.domain.Language;
import foodiepass.server.domain.OrderItem;
import foodiepass.server.domain.Script;
import foodiepass.server.domain.ScriptGenerator;
import foodiepass.server.dto.request.MenuItemRequest;
import foodiepass.server.dto.request.ScriptGenerateRequest;
import foodiepass.server.dto.response.ScriptResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScriptService {

    private final ScriptGenerator scriptGenerator;

    public ScriptResponse generateScript(final ScriptGenerateRequest request) {
        final Language sourceLanguage = Language.fromLanguageName(request.userLanguageName());
        final Language targetLanguage = Language.fromLanguageName(request.originLanguageName());

        final List<OrderItem> orderItems = request.menuItems()
                .stream()
                .map(MenuItemRequest::toDomain)
                .toList();

        final Script script = scriptGenerator.generate(sourceLanguage, targetLanguage, orderItems);

        return new ScriptResponse(script.userScript(), script.originScript());
    }
}
