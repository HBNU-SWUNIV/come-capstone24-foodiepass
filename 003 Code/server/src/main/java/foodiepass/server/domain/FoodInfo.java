package foodiepass.server.domain;

public record FoodInfo(
        String name,
        String image,
        String previewImage,
        String description
) {
}
