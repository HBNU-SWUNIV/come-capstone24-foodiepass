
package foodiepass.server.domain;

public record OrderItem(String originMenuName, String userMenuName, int quantity) {
}