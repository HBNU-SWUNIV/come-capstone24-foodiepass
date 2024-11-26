package foodiepass.server.dto.request;

import foodiepass.server.domain.OrderItem;

public record MenuItemRequest(
        String originMenuName,
        String userMenuName,
        int quantity
) {
    public OrderItem toDomain() {
        return new OrderItem(originMenuName, userMenuName, quantity);
    }
}