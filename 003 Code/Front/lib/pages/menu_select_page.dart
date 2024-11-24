import 'package:flutter/material.dart';
import 'package:foodiepass_android/pages/food_detail_page.dart';
import 'package:foodiepass_android/pages/order_list_page.dart';
import 'package:foodiepass_android/models/menu.dart';

class MenuSelectPage extends StatefulWidget {
  final List<Menu> menuList;

  const MenuSelectPage({super.key, required this.menuList});

  @override
  _MenuSelectPageState createState() => _MenuSelectPageState();
}

class _MenuSelectPageState extends State<MenuSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderListPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 2개의 항목
                crossAxisSpacing: 8, // 항목 사이의 가로 간격
                mainAxisSpacing: 8, // 항목 사이의 세로 간격
                childAspectRatio: 0.75, // 항목의 가로 세로 비율
              ),
              itemCount: widget.menuList.length,
              itemBuilder: (context, index) {
                return MenuItemCard(item: widget.menuList[index]);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Review Order',
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
        ],
      ),
    );
  }
}

// 개별 메뉴 아이템을 표시하는 카드 위젯
class MenuItemCard extends StatelessWidget {
  final Menu item;

  const MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailPage(item: item), // MenuItem 전달
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 메뉴 이미지
            Expanded(
              child: Container(
                color: Colors.white,
                child: Image.network(
                  item.previewImage ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/food_menu/ImageNotFound.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // 메뉴 텍스트 정보 (이름, 가격)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.destinationName.length > 10
                        ? '${item.destinationName.substring(0, 10)}...'
                        : item.destinationName,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.profileName.length > 10
                        ? '${item.profileName.substring(0, 10)}...'
                        : item.profileName,
                    style: TextStyle(fontSize: 16),
                  ),

                  SizedBox(height: 4),
                  Text(item.destinationPriceWithCurrencyUnit),
                  Text(item.profilePriceWithCurrencyUnit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
