package foodiepass.server.external;

import com.fasterxml.jackson.annotation.JsonProperty;
import foodiepass.server.exception.CustomerException;
import lombok.Data;
import java.util.List;
import static foodiepass.server.exception.enums.ErrorMessage.FOOD_NOT_FOUND;

@Data
public class TasteAtlasResponse {

    @JsonProperty("CustomItems")
    private List<Item> customItems;

    @JsonProperty("Items")
    private List<Item> items;

    public Item findFirst() {
        return customItems.stream()
                .findFirst()
                .orElseGet(this::findItems);
    }

    private Item findItems() {
        return items.stream()
                .findFirst()
                .orElseThrow(() -> new CustomerException(FOOD_NOT_FOUND));
    }

    @Data
    public static class Item {

        @JsonProperty("EntityId")
        private int EntityId;
        @JsonProperty("EntityId2")
        private Integer EntityId2;
        @JsonProperty("Name")
        private String Name;
        @JsonProperty("OtherName")
        private String OtherName;
        @JsonProperty("Subtitle")
        private String Subtitle;
        @JsonProperty("EntityType")
        private int EntityType;
        @JsonProperty("PreviewImage")
        private PreviewImage PreviewImage;
        @JsonProperty("UrlLink")
        private String UrlLink;
        @JsonProperty("TypeOverride")
        private String TypeOverride;

        public String generateFullName() {
            if (OtherName == null) {
                return Name;
            }
            return String.format("%s (%s)", Name, OtherName);
        }
    }

    @Data
    public static class PreviewImage {

        @JsonProperty("Image")
        private String Image;
        @JsonProperty("Source")
        private String Source;
        @JsonProperty("SourceUrl")
        private String SourceUrl;
    }
}
