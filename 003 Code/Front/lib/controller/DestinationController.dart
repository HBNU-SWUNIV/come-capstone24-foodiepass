import 'package:get/get.dart';

class DestinationController extends GetxController {
  String _destinationLanguage = 'English(US)';
  String _destinationCurrency = 'USD';

  get destinationLanguage => _destinationLanguage;
  get destinationCurrency => _destinationCurrency;

  void changeDestination(String destinationLanguage, String destinationCurrency) {
    _destinationLanguage = destinationLanguage;
    _destinationCurrency = destinationCurrency;
    update();
  }
}