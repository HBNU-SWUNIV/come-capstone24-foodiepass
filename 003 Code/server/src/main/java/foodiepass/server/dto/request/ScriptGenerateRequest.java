package foodiepass.server.dto.request;


import java.util.List;

public record ScriptGenerateRequest(
        List<MenuItemRequest> menuItems,
        String originLanguageName,
        String userLanguageName
) {
}
