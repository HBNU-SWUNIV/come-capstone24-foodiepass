class TotalPrice {
  final String totalDestinationPriceWithCurrencyUnit;
  final String totalProfilePriceWithCurrencyUnit;

  TotalPrice.fromJson(Map<String, dynamic> json)
      : totalDestinationPriceWithCurrencyUnit = json['totalPriceWithOriginCurrencyUnit'],
        totalProfilePriceWithCurrencyUnit = json['totalPriceWithUserCurrencyUnit'];
}