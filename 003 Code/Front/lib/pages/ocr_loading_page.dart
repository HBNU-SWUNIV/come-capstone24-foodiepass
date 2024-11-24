import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodiepass_android/controller/destination_controller.dart';
import 'package:foodiepass_android/controller/order_list_controller.dart';
import 'package:foodiepass_android/controller/profile_controller.dart';
import 'package:foodiepass_android/external/api_service.dart';
import 'package:foodiepass_android/models/menu.dart';
import 'package:foodiepass_android/pages/menu_select_page.dart';
import 'package:get/get.dart';

class OcrLoadingPage extends StatefulWidget {
  final String base64Image;

  const OcrLoadingPage({super.key, required this.base64Image});

  @override
  State<StatefulWidget> createState() => _OcrLoadingPageState();
}

class _OcrLoadingPageState extends State<OcrLoadingPage> {
  late Future<List<Menu>> menuList;
  late ProfileController profileController;
  late DestinationController destinationController;

  OrderListController orderListController = Get.put(
      OrderListController(), permanent: true);

  bool hasNavigated = false; // 네비게이션 중복 호출 방지를 위한 변수

  @override
  void initState() {
    super.initState();

    profileController = Get.put(ProfileController());
    destinationController = Get.put(DestinationController());

    // 서버에서 menuList 가져오기 시작
    menuList = ApiService.postPictureAndGetMenu(
      destinationLanguage: destinationController.destinationLanguage,
      profileLanguage: profileController.profileLanguage,
      destinationCurrency: destinationController.destinationCurrency,
      profileCurrency: profileController.profileCurrency,
      base64EncodedImage: widget.base64Image,
    );

    Get.find<OrderListController>().initCart();
  }

  void clickBackButton() {
    Navigator.pop(context);
    print("click go back button");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(' '),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            clickBackButton();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Menu>>(
        future: menuList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 로딩 중 화면
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SvgPicture.asset('assets/images/loadingImage.svg'),
                  const SizedBox(height: 20),
                  const Text(
                    '당신만을 위한 특별한 메뉴판을 제작하고 있습니다...',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // 에러 화면
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Error loading menu',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      clickBackButton();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && !hasNavigated) {
            // 데이터 로드 완료 시 MenuSelectPage로 이동
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!hasNavigated) {
                hasNavigated = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuSelectPage(menuList: snapshot.data!),
                  ),
                );
              }
            });
            return const SizedBox.shrink(); // 이동 전 빈 화면
          } else {
            return const Center(
              child: Text('No menu data available.'),
            );
          }
        },
      ),
    );
  }
}