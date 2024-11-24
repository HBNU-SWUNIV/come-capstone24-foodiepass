class Currency {
  final String currency;

  Currency.fromJson(Map<String, dynamic> json)
      : currency = json['currencyName'];
}
