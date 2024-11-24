import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodiepass_android/models/currency.dart';
import 'package:foodiepass_android/models/item_price_for_script.dart';
import 'package:foodiepass_android/models/menu.dart';
import 'package:foodiepass_android/models/language.dart';
import 'package:foodiepass_android/models/order_item_for_script.dart';
import 'package:foodiepass_android/models/order_list.dart';
import 'package:foodiepass_android/models/script.dart';
import 'package:foodiepass_android/models/total_price.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseURL = dotenv.env['BASE_URL']!;
  static const String language = 'language';
  static const String currency = 'currency';
  static const String reconfigure = 'reconfigure';
  static const String script = 'script';
  static const String calculate = 'calculate';

  // language list
  static Future<List<Language>> getLanguages() async {
    List<Language> languageList = [];
    final url = Uri.parse('$baseURL/$language');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      const String errorMessage = '언어 리스트 받아오기를 실패하였습니다.';
      throw Exception(errorMessage);
    }
    final List<dynamic> responseList = jsonDecode(response.body);
    languageList =
        responseList.map((language) => Language.fromJson(language)).toList();

    return languageList;
  }

  // currency list
  static Future<List<Currency>> getCurrencies() async {
    List<Currency> currencyList = [];
    final url = Uri.parse('$baseURL/$currency');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      const String errorMessage = '화폐 리스트 받아오기를 실패하였습니다.';
      throw Exception(errorMessage);
    }

    final List<dynamic> responseList = jsonDecode(response.body);
    currencyList = responseList
        .map((currency) => Currency.fromJson(currency))
        .toList();

    return currencyList;
  }

  // send Photo get Menu
  static Future<List<Menu>> postPictureAndGetMenu(
      {required String destinationLanguage,
        required String profileLanguage,
        required String destinationCurrency,
        required String profileCurrency,
        required String base64EncodedImage}) async {

    List<Menu> menuList = [];

    final body = {
      "originLanguageName": destinationLanguage,
      "userLanguageName": profileLanguage,
      "originCurrencyName": destinationCurrency,
      "userCurrencyName": profileCurrency,
      "base64EncodedImage": base64EncodedImage
    };

    final header = {'Content-Type': 'application/json; charset=UTF-8'};
    final url = Uri.parse('$baseURL/$reconfigure');

    final response = await http.post(url, body: jsonEncode(body), headers: header);

    if (response.statusCode != 200) {
      const String errorMessage = '메뉴판 리스트 받아오기를 실패하였습니다.';
      throw Exception(errorMessage);
    }
    final List<dynamic> responseList =
    jsonDecode(utf8.decode(response.bodyBytes));
    menuList = responseList.map((menu) => Menu.fromJson(menu)).toList();
    return menuList;
  }

  // order script
  static Future<Script> postMenuListAndGetScript(
      List<OrderList> orderMenuList,
      String destinationLanguage,
      String profileLanguage) async {

    List<OrderItemForScript> menuItems = orderMenuList
        .map((orderMenu) => OrderItemForScript(
        destinationName: orderMenu.menu.destinationName,
        profileName: orderMenu.menu.profileName,
        quantity: orderMenu.quantity))
        .toList();

    final body = {
      'menuItems': menuItems.map((item) => item.toObject()).toList(),
      'originLanguageName': destinationLanguage,
      'userLanguageName': profileLanguage,
    };

    final header = {'Content-Type': 'application/json; charset=UTF-8'};
    final url = Uri.parse('$baseURL/script');
    final response =
    await http.post(url, body: jsonEncode(body), headers: header);

    if (response.statusCode != 200) {
      const String errorMessage = '스크립트 받아오기를 실패하였습니다.';
      throw Exception(errorMessage);
    }

    final script = Script.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return script;
  }

  //계산서 받기
  static Future<TotalPrice> postOrderAndGetReceipt(
      List<OrderList> orderMenuList,
      String originCurrency,
      String userCurrency) async {
    List<ItemPriceForScript> orders = orderMenuList
        .map((orderMenu) => ItemPriceForScript(
        destinationPrice: orderMenu.menu.destinationPrice,
        profilePrice: orderMenu.menu.profilePrice,
        quantity: orderMenu.quantity))
        .toList();

    final body = {
      'orders': orders.map((item) => item.toObject()).toList(),
      'originCurrency': originCurrency,
      'userCurrency': userCurrency,
    };

    final header = {'Content-Type': 'application/json; charset=UTF-8'};
    final url = Uri.parse('$baseURL/$currency/$calculate');
    final response =
    await http.post(url, body: jsonEncode(body), headers: header);

    if (response.statusCode != 200) {
      const String errorMessage = '영수증 받아오기를 실패하였습니다.';
      throw Exception(errorMessage);
    }
    final receipt =
    TotalPrice.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return receipt;
  }
}