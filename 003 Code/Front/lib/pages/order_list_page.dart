import 'package:flutter/material.dart';
import 'package:foodiepass_android/pages/order_script_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:foodiepass_android/models/menu.dart';
import 'package:foodiepass_android/models/order_list.dart';
import 'package:foodiepass_android/controller/order_list_controller.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrderListController orderListController = Get.put(OrderListController());

  void finishOrder() {
    Get.to(() => const OrderScriptPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Menu',
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

        leading: SizedBox(
          width: 100,
          height: 50,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<OrderListController>(
        builder: (controller) {
          return controller.orderList.isEmpty
              ? const Center(
            child: Text(
              '주문 내용이 비어있습니다.\n이전 페이지로 돌아가 주문을 추가해주세요.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          )
              : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: controller.orderList.length,
              itemBuilder: (context, index) {
                final item = controller.orderList[index];
                final double profileTotalPrice =
                    item.menu.profilePrice * item.quantity;
                final double destinationTotalPrice =
                    item.menu.destinationPrice * item.quantity;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.lightGreen, width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.menu.image ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/food_menu/ImageNotFound.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.menu.profileName,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${item.menu.profilePriceWithCurrencyUnit.substring(0, 1)} ${profileTotalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.menu.destinationName,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                    overflow:
                                    TextOverflow.ellipsis, // 줄내림 대신 ... 처리
                                    maxLines: 1, // 한 줄로 제한
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${item.menu.destinationPriceWithCurrencyUnit.substring(0, 1)} ${destinationTotalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  controller.deleteMenu(item);
                                },
                                icon: const Icon(Icons.delete)),
                            SizedBox(width: 15,),
                            IconButton(
                              onPressed: () {
                                controller.minusQuantity(item);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              item.quantity.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(width: 5,),
                            IconButton(
                              onPressed: () {
                                controller.plusQuantity(item);
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 위쪽에 추가할 텍스트
            GetBuilder<OrderListController>(
              builder: (controller) {
                final totalPrice = controller.orderList.fold(
                  {'profileTotalPrice': 0.0, 'destinationTotalPrice': 0.0},
                      (acc, item) {
                    acc['profileTotalPrice'] +=
                        item.menu.profilePrice * item.quantity;
                    acc['destinationTotalPrice'] +=
                        item.menu.destinationPrice * item.quantity;
                    return acc;
                  },
                );
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '총 가격: ${controller.orderList.isNotEmpty ? controller.orderList[0].menu.profilePriceWithCurrencyUnit.substring(0, 1) : ''} ${totalPrice['profileTotalPrice'].toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Total Price: ${controller.orderList.isNotEmpty ? controller.orderList[0].menu.destinationPriceWithCurrencyUnit.substring(0, 1) : ''} ${totalPrice['destinationTotalPrice'].toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
            // 하단 버튼
            GetBuilder<OrderListController>(
              builder: (controller) {
                return controller.orderList.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                  height: 48, // 버튼 높이
                  decoration: ShapeDecoration(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      finishOrder();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          "Finish Order",
                          style: TextStyle(
                            color: Colors.white, // 텍스트 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
