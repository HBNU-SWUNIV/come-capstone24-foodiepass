import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../controller/DestinationController.dart';

class DestinationSettingPage extends StatefulWidget {
  const DestinationSettingPage({super.key});

  @override
  State<DestinationSettingPage> createState() => _DestinationSettingPageState();
}

class _DestinationSettingPageState extends State<DestinationSettingPage> {
  late String destinationLanguage;
  late String destinationCurrency;

  final DestinationController destinationController =
      Get.put(DestinationController());
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // 여행지 언어와 화폐 초기화
    destinationLanguage = destinationController.destinationLanguage;
    destinationCurrency = destinationController.destinationCurrency;
  }

  void showLanguageList() {
    // TODO: 언어 목록 보여주기
    print('click language list button');
  }

  void showCurrencyList() {
    // TODO: 화폐 목록 보여주기
    print('click currency list button');
  }

  void _submitDestinationInfo(BuildContext context) async {
    // 설정한 여행지 정보를 저장한 뒤에 뒤로 가기
    await flutterSecureStorage.write(
        key: 'destinationLanguage', value: destinationLanguage);
    await flutterSecureStorage.write(
        key: 'destinationCurrency', value: destinationCurrency);

    destinationController.changeDestination(
        destinationLanguage, destinationCurrency);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "여행지 설정",
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "어디에서 새로운 미식을 즐기고 계신가요?\n여행지를 선택하세요.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "언어",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                showLanguageList();
              },
              child: Container(
                width: double.infinity,
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<DestinationController>(
                      builder: (destinationController) => Text(
                        '${destinationController.destinationLanguage}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "화폐",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                showCurrencyList();
              },
              child: Container(
                width: double.infinity,
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<DestinationController>(
                      builder: (destinationController) => Text(
                        '${destinationController.destinationCurrency}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: ShapeDecoration(
          color: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            _submitDestinationInfo(context);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                "완료",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
