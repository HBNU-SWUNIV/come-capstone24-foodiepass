import 'package:get/get.dart';

class ProfileController extends GetxController {
  String _profileLanguage = 'Korean';
  String _profileCurrency = 'KRW';

  get profileLanguage => _profileLanguage;
  get profileCurrency => _profileCurrency;

  void changeProfile(String profileLanguage, String profileCurrency) {
    _profileLanguage = profileLanguage;
    _profileCurrency = profileCurrency;
    update();
  }
}