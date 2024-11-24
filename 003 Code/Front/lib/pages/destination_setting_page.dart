import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodiepass_android/controller/destination_controller.dart';
import 'package:foodiepass_android/external/api_service.dart';
import 'package:foodiepass_android/models/currency.dart';
import 'package:foodiepass_android/models/language.dart';
import 'package:get/get.dart';

class DestinationSettingPage extends StatefulWidget {
  const DestinationSettingPage({super.key});

  @override
  State<DestinationSettingPage> createState() => _DestinationSettingPageState();
}

class _DestinationSettingPageState extends State<DestinationSettingPage> {
  late String destinationLanguage;
  late String destinationCurrency;
  late Future<List<Language>> languages;
  late Future<List<Currency>> currencies;

  final DestinationController destinationController =
  Get.put(DestinationController());
  final FlutterSecureStorage flutterSecureStorage =
  const FlutterSecureStorage();

  TextEditingController searchLanguageController = TextEditingController();
  TextEditingController searchCurrencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    languages = ApiService.getLanguages();
    currencies = ApiService.getCurrencies();

    // 여행지 언어와 화폐 초기화
    destinationLanguage = destinationController.destinationLanguage;
    destinationCurrency = destinationController.destinationCurrency;
  }

  void _showLanguageList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Language>>(
          future: languages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: \${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchLanguageController,
                      decoration: const InputDecoration(
                        labelText: 'Select Language',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var country = snapshot.data![index];
                        // 검색어로 필터링
                        if (country.language.toLowerCase().contains(
                            searchLanguageController.text.toLowerCase())) {
                          return ListTile(
                            title: Text(country.language),
                            onTap: () {
                              setState(() {
                                destinationLanguage = country.language;
                                destinationLanguage = country.language;
                              });
                              Get.back();
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _showCurrencyList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Currency>>(
          future: currencies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: \${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchCurrencyController,
                    decoration: const InputDecoration(
                      labelText: 'Select Currency',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var currency = snapshot.data![index];
                      // 검색어로 필터링
                      if (currency.currency.toLowerCase().contains(
                          searchCurrencyController.text.toLowerCase())) {
                        return ListTile(
                          title: Text(currency.currency),
                          onTap: () {
                            setState(() {
                              destinationCurrency = currency.currency;
                              destinationCurrency = currency.currency;
                            });
                            Get.back();
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ]);
            }
          },
        );
      },
    );
  }

  void _submitDestinationInfo(BuildContext context) async {
    // 설정한 여행지 정보를 저장한 뒤에 뒤로 가기
    await flutterSecureStorage.write(
        key: 'destinationLanguage', value: destinationLanguage);
    await flutterSecureStorage.write(
        key: 'destinationCurrency', value: destinationCurrency);

    destinationController.changeDestination(
        destinationLanguage, destinationCurrency);

    destinationLanguage = destinationLanguage;
    destinationCurrency = destinationCurrency;

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
                _showLanguageList(context);
              },
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // 텍스트 길이 제어를 위해 Expanded 추가
                      child: GetBuilder<DestinationController>(
                        builder: (destinationController) => Text(
                          destinationLanguage,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis, // 초과 시 ... 처리
                          maxLines: 1, // 한 줄로 제한
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.grey,
                    ),
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
                _showCurrencyList(context);
              },
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // 텍스트 길이 제어를 위해 Expanded 추가
                      child: GetBuilder<DestinationController>(
                        builder: (destinationController) => Text(
                          destinationCurrency,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis, // 초과 시 ... 처리
                          maxLines: 1, // 한 줄로 제한
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.grey,
                    ),
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
