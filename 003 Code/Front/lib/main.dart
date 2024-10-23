import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodiepass_android/controller/DestinationController.dart';
import 'package:foodiepass_android/controller/ProfileController.dart';
import 'package:foodiepass_android/pages/profile_setting_page.dart';
import 'package:get/get.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FoodiePass());
}

class FoodiePass extends StatelessWidget {
  const FoodiePass({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodiePass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FlutterSecureStorage secureStorage;

  @override
  void initState() {
    super.initState();
    secureStorage = const FlutterSecureStorage();
    _checkAndNavigate(); // 저장소 확인 및 적절한 화면으로 이동
  }

  Future<void> _checkAndNavigate() async {

    String? profileLanguage = await secureStorage.read(key: 'profileLanguage');
    String? profileCurrency = await secureStorage.read(key: 'profileCurrency');
    String? destinationLanguage =
    await secureStorage.read(key: 'destinationLanguage');
    String? destinationCurrency =
    await secureStorage.read(key: 'destinationCurrency');

    if (profileLanguage != null && profileCurrency != null) {
      // 내 국가와 통화 정보가 있는 경우
      final controller = Get.put(ProfileController());
      controller.changeProfile(profileLanguage, profileCurrency); // 내 국가 및 통화 수정
      if (destinationLanguage != null) {
        // 여행 언어 정보가 있는 경우
        final destinationController = Get.put(DestinationController());
        destinationController.changeDestination(
            destinationLanguage, destinationCurrency!); // 여행 언어 및 통화 수정
      }

      Get.off(() => const HomePage());
    } else {
      // 내 국가와 통화 정보가 없는 경우
      Get.off(() => const ProfileSettingPage(fromHomePage: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/splashIcon.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: LinearProgressIndicator(
                minHeight: 8.0,
                backgroundColor: Colors.grey[300],
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}