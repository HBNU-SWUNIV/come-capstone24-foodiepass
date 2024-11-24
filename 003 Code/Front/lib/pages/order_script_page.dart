import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodiepass_android/models/script.dart';
import 'package:foodiepass_android/controller/destination_controller.dart';
import 'package:foodiepass_android/controller/profile_controller.dart';
import 'package:foodiepass_android/controller/order_list_controller.dart';
import 'package:foodiepass_android/external/api_service.dart';
import 'home_page.dart';

class OrderScriptPage extends StatefulWidget {
  const OrderScriptPage({super.key});

  @override
  State<OrderScriptPage> createState() => _OrderScriptPageState();
}

class _OrderScriptPageState extends State<OrderScriptPage> {
  final DestinationController destinationController = Get.put(DestinationController());
  final ProfileController profileController = Get.put(ProfileController());
  final OrderListController orderListController = Get.put(OrderListController());

  late Future<Script> script;

  @override
  void initState() {
    super.initState();
    // 번역 요청 준비
    script = ApiService.postMenuListAndGetScript(
      orderListController.orderList,
      destinationController.destinationLanguage,
      profileController.profileLanguage,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 60.0;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bodyHeight = screenHeight - appBarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: appBarHeight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                clickHomeButton();
              },
              icon: const Icon(
                Icons.home,
                size: 30,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Script>(
        future: script,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 번역 중일 때 로딩 화면 표시
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('스크립트 번역중', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // 에러가 발생했을 때 에러 메시지 표시
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 18)),
            );
          } else if (!snapshot.hasData) {
            // 데이터가 없을 때 메시지 표시
            return Center(
              child: Text('No data available', style: TextStyle(fontSize: 18)),
            );
          } else {
            // 번역된 스크립트를 화면에 표시
            String translatedDestinationOrderMessage = snapshot.data!.destinationScript;
            String translatedProfileOrderMessage = snapshot.data!.profileScript;

            return SizedBox(
              height: bodyHeight,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Transform.rotate(
                            angle: math.pi,
                            child: Text(
                              translatedDestinationOrderMessage,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Transform.rotate(
                            angle: math.pi,
                            child: const Text(
                              'Order',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Divider(
                        thickness: 2,
                        color: Colors.grey,
                        height: 0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '당신의 주문',
                            style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            translatedProfileOrderMessage,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            finishOrder();
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
              "Bon appétit!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void clickBackButton() {
    Get.back();
  }

  void clickHomeButton() {
    Get.offAll(() => const HomePage());
  }

  void finishOrder() {
    Get.offAll(() => const HomePage());
  }
}
