import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodiepass_android/controller/destination_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodiepass_android/pages/destination_setting_page.dart';
import 'package:foodiepass_android/pages/profile_setting_page.dart';
import 'package:foodiepass_android/pages/ocr_loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DestinationController destinationController =
  Get.put(DestinationController());

  final picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();
      String base64EncodedImage = base64Encode(imageBytes);
      Get.to(() => OcrLoadingPage(base64Image: base64EncodedImage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            const SizedBox(height: 5,),
            AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'FoodiePass',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 60),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 80,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 400,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _pickImageFromCamera();
              },
              child: Container(
                height: 350,
                width: 350,
                child: SvgPicture.asset('assets/images/home/startButton.svg'),
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.lightGreen),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '여행지',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.airplane_ticket_outlined,
                        size: 90,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 35),

                      Column(
                        children: [

                          GetBuilder<DestinationController>(
                            builder: (destinationController) => ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150), // 최대 너비 지정
                              child: Text(
                                destinationController.destinationLanguage,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis, // 텍스트가 너무 길 경우 생략 부호(...)를 추가
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          GetBuilder<DestinationController>(
                            builder: (destinationController) => ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150), // 최대 너비 지정
                              child: Text(
                                destinationController.destinationCurrency,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis, // 텍스트가 너무 길 경우 생략 부호(...)를 추가
                              ),
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingPage(fromHomePage: true),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    '프로필 설정 >',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DestinationSettingPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    '여행지 설정 >',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'made by TEAM FoodiePass',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}