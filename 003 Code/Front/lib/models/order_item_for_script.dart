class OrderItemForScript {
  final String destinationName, profileName;
  final int quantity;

  OrderItemForScript(
      {required this.destinationName,
      required this.profileName,
      required this.quantity});

  Map<String, dynamic> toObject() {
    return {
      'originMenuName': destinationName,
      'userMenuName': profileName,
      'quantity': quantity
    };
  }
}
