import 'package:flutter/material.dart';
import 'package:foodiepass_android/controller/order_list_controller.dart';
import 'package:foodiepass_android/models/order_list.dart';
import 'package:foodiepass_android/pages/order_list_page.dart';
import 'package:foodiepass_android/models/menu.dart';
import 'package:get/get.dart';

class FoodDetailPage extends StatefulWidget {
  final Menu item; // MenuItem 객체
  const FoodDetailPage({super.key, required this.item});

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final orderListController = Get.put(OrderListController(), permanent: true);

  int quantity = 0;

  bool isZero() {
    return quantity == 0;
  }

  @override
  Widget build(BuildContext context) {
    double destinationTotalPrice = widget.item.destinationPrice * quantity;
    double profileTotalPrice = widget.item.profilePrice * quantity;

    return Scaffold(
      backgroundColor: Colors.white, // 페이지 전체 배경 흰색
      appBar: AppBar(
        title: Text(
          widget.item.destinationName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, size: 30, color: Colors.black),
            onPressed: () {
              Get.to(() => OrderListPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.item.image ?? '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/food_menu/ImageNotFound.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              widget.item.destinationName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              widget.item.profileName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              widget.item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '여행지 가격',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.item.destinationPriceWithCurrencyUnit,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '환산 가격',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.item.profilePriceWithCurrencyUnit,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '수량',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: quantity > 0
                          ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                          : null, // 수량이 0 이상일 때만 감소 가능
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '총 가격',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.item.destinationPriceWithCurrencyUnit.substring(0, 1)} ${destinationTotalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${widget.item.profilePriceWithCurrencyUnit.substring(0, 1)} ${profileTotalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (isZero()) {
                      return; // 수량이 0일 경우 버튼이 동작하지 않음
                    }
                    final orderMenu =
                    OrderList(menu: widget.item, quantity: quantity);
                    orderListController.addMenu(orderMenu);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Add Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
