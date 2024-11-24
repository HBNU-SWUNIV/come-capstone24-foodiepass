class ItemPriceForScript {
  final double destinationPrice, profilePrice;
  final int quantity;

  ItemPriceForScript(
      {required this.destinationPrice,
      required this.profilePrice,
      required this.quantity});

  Map<String, dynamic> toObject() {
    return {
      'originPrice': destinationPrice,
      'userPrice': profilePrice,
      'quantity': quantity,
    };
  }
}
