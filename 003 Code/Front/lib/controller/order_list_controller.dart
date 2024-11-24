import 'package:foodiepass_android/models/order_list.dart';
import 'package:get/get.dart';

class OrderListController extends GetxController {
  final List<OrderList> _orderList = [];

  get orderList => _orderList;

  void addMenu(OrderList food) {
    _orderList.add(food);
    update();
  }

  void deleteMenu(OrderList food) {
    _orderList.remove(food);
    update();
  }

  void minusQuantity(OrderList food) {
    final index = _orderList.indexOf(food);
    if (index != -1) {
      if (_orderList[index].quantity > 1) {
        _orderList[index].quantity -= 1;
        update();
      }
    }
  }

  void plusQuantity(OrderList food) {
    final index = _orderList.indexOf(food);
    if (index != -1) {
      _orderList[index].quantity += 1;
      update();
    }
  }

  void initCart() {
    _orderList.clear();
    update();
  }

  bool isEmptyOrderList() {
    return _orderList.isEmpty;
  }
}