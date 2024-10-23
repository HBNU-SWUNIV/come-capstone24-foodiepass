import 'package:flutter/material.dart';
import 'package:foodiepass_android/pages/order_script_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:foodiepass_android/models/food.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<Map<String, dynamic>> foodItems = [];

  @override
  void initState() {
    super.initState();
    // foodItems 초기화
    foodItems = menuItems
        .where((item) => item.quantity > 0)
        .map((item) => {
              'profileName': item.profileName,
              'destinationName': item.destinationName,
              'image':
                  item.imagePath ?? 'assets/images/food_menu/ImageNotFound.png',
              'profilePrice': item.profilePrice,
              'destinationPrice': item.destinationPrice,
              'quantity': item.quantity,
              'food': item, // Food 객체 참조 추가
            })
        .toList();
  }

  // NumberFormat을 사용하여 통화 형식 지정
  final NumberFormat krwFormat =
      NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
  final NumberFormat usdFormat =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  Widget build(BuildContext context) {
    final totalPrice = getTotalPrice();

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
        // 앱바 높이 설정

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
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final item = foodItems[index];
            final double profileTotalPrice =
                item['profilePrice'] * item['quantity'];
            final double destinationTotalPrice =
                item['destinationPrice'] * item['quantity'];

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
                            image: DecorationImage(
                              image: AssetImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['profileName'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${krwFormat.format(profileTotalPrice)}',
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
                                item['destinationName'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                overflow:
                                    TextOverflow.ellipsis, // 줄내림 대신 ... 처리
                                maxLines: 1, // 한 줄로 제한
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${usdFormat.format(destinationTotalPrice)}',
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
                              deleteItem(index);
                            },
                            icon: const Icon(Icons.delete)),
                        SizedBox(width: 15,),
                        IconButton(
                          onPressed: () {
                            decrementQuantity(index);
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          item['quantity'].toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 5,),
                        IconButton(
                          onPressed: () {
                            incrementQuantity(index);
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 위쪽에 추가할 텍스트
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                '총 가격: ${krwFormat.format(totalPrice['profileTotalPrice'])}\nTotal Price: ${usdFormat.format(totalPrice['destinationTotalPrice'])}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            // 하단 버튼
            Container(
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
            ),
          ],
        ),
      ),
    );
  }

  void finishOrder() {
    Get.to(() => const OrderScriptPage());
  }

  void incrementQuantity(int index) {
    setState(() {
      foodItems[index]['quantity']++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (foodItems[index]['quantity'] > 1) {
        foodItems[index]['quantity']--; // 수량 감소
      }
    });
  }

  void deleteItem(int index) {
    setState(() {
      // Food 객체의 quantity를 0으로 설정
      Food food = foodItems[index]['food'];
      food.quantity = 0;
      foodItems.removeAt(index);
    });
  }

  // 총 가격 계산 함수
  Map<String, dynamic> getTotalPrice() {
    num profileTotalPrice = 0;
    num destinationTotalPrice = 0.0;

    for (var item in foodItems) {
      profileTotalPrice += item['profilePrice'] * item['quantity'];
      destinationTotalPrice += item['destinationPrice'] * item['quantity'];
    }

    return {
      'profileTotalPrice': profileTotalPrice,
      'destinationTotalPrice': destinationTotalPrice
    };
  }
}
