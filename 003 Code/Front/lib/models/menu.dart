class Menu {
  final String destinationName; // 메뉴 이름
  final String profileName;
  final String? previewImage;
  final String? image; // 이미지 파일 경로 (null 허용)
  final double destinationPrice;
  final String destinationPriceWithCurrencyUnit;
  final double profilePrice;
  final String profilePriceWithCurrencyUnit;
  final String description; // 음식 설명

  Menu.fromJson(Map<String, dynamic> json)
      : destinationName = json['originMenuName'],
        profileName = json['userMenuName'],
        previewImage = json['previewImageUrl'],
        image = json['imageUrl'],
        destinationPrice = json['originPrice'],
        destinationPriceWithCurrencyUnit = json['originPriceWithCurrencyUnit'],
        profilePrice = json['userPrice'],
        profilePriceWithCurrencyUnit = json['userPriceWithCurrencyUnit'],
        description = json['description'];

}