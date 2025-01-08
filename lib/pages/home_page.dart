import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneakerstore_client/controller/home_controller.dart';
import 'package:sneakerstore_client/pages/product_description_page.dart';
import 'package:sneakerstore_client/pages/profile_page.dart';
import 'package:sneakerstore_client/widget/drop_down_buton.dart';
import 'package:sneakerstore_client/widget/multi_select_drop_down.dart';
import 'package:sneakerstore_client/widget/product_widget.dart';

import '../controller/login_controller.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'orders_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Điều hướng sang các trang khác nhau bằng Get.to()
    switch (index) {
      case 0:
        Get.to(() => HomePage());
        break;

      case 1:
        Get.to(() =>  OrderHistoryView());
        break;
      case 2:
        Get.to(() =>  ProfilePage());
        break;
      case 3:
        Get.to(() =>   CartPage());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E1E1E),
                    Color(0xFF3E3E3E),
                  ],
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: GestureDetector(
                  onTap: () => Get.to(() => ProfilePage()),
                  child: CircleAvatar(
                    backgroundImage: LoginController().LoginUser?.profilePicture != null
                        ? NetworkImage(LoginController().LoginUser!.profilePicture!)
                        : null,
                    backgroundColor: Colors.grey[800],
                    child: LoginController().LoginUser?.profilePicture == null
                        ? Icon(Icons.person, color: Colors.white70)
                        : null,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wismo sneaker',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Find your perfect pair',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    child: IconButton(
                      onPressed: () => LoginController().logout(),
                      icon: const Icon(Icons.logout, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ],
          ),

          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search sneakers...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          onChanged: (value) {
                            ctrl.searchProducts(value); // Gọi hàm tìm kiếm trong HomeController
                          },
                        ),

                      ),
                    ),

                    // Categories
                    Container(
                      height: 65,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: ctrl.productcategories.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(25),
                              child: InkWell(
                                onTap: () {
                                  ctrl.filterByCategory(
                                      ctrl.productcategories[index].name ?? '');
                                },
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF1E1E1E),
                                        Color(0xFF3E3E3E),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [

                                      const SizedBox(width: 8),
                                      Text(
                                        ctrl.productcategories[index].name ??
                                            'Error',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // After the search bar and before categories section, add:

                    Container(
                      height: 200, // Tăng chiều cao để đảm bảo không gian thoải mái
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: PageView(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF4A90E2), Color(0xFF9013FE)], // Xanh dương và tím

                              ),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none, // Tránh cắt nội dung
                              children: [
                                // Hình ảnh
                                Positioned(
                                  right: -40, // Điều chỉnh căn sát phải
                                  top: -70, // Nhẹ nhàng hạ thấp
                                  child: Transform.rotate(
                                    angle: -0.6, // Giảm độ nghiêng để trông tự nhiên hơn
                                    child: Image.asset(
                                      'assets/images/sneaker.png', // Thay bằng ảnh trong thư mục của bạn
                                      height: 340, // Giảm kích thước hình ảnh để vừa vặn
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.sports_soccer,
                                        size: 100,
                                        color: Colors.white24,
                                      ),
                                    ),
                                  ),
                                ),
                                // Nội dung
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'New Arrival',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Nike Air Max 2024',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Starting from \$199',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Shop Now',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Thêm các slide khác nếu cần
                        ],
                      ),
                    ),




                    // Filters
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropDownBtn(
                                items: const [
                                  'Giá cao đến thấp',
                                  'Giá Thấp đến cao'
                                ],
                                selectedItemText: 'Lọc theo giá',
                                onSelected: (selected) {
                                  ctrl.sortByPrice(
                                      ascending: selected == 'Giá Thấp đến cao'
                                          ? true
                                          : false);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: MultiSelectDropDown(
                                items: [
                                  'Adidas',
                                  'New Balance',
                                  'Timberland',
                                  'Vans',
                                  'Nike',
                                  'Converse'
                                ],
                                onSelectionChanged: (selectedItems) {
                                  ctrl.filterByBrand(selectedItems);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Products Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ProductWidget(
                        name: ctrl.productShowinUI[index].name ?? 'Không tên',
                        imageUrl:
                        ctrl.productShowinUI[index].image ?? 'Không tên',
                        price: ctrl.productShowinUI[index].price ?? 0,
                        offer: '30% off',
                        onTap: () {
                          Get.to(ProductDescriptionPage(),
                              arguments: {'data': ctrl.productShowinUI[index]});
                        },
                      );
                    },
                    childCount: ctrl.productShowinUI.length,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap:  _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF1E1E1E),
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0
                          ? Colors.grey[100]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home_outlined),
                  ),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home),
                  ),
                  label: 'Home',
                ),

                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 2
                          ? Colors.grey[100]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.receipt_long_sharp),
                  ),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.history_edu),
                  ),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 3
                          ? Colors.grey[100]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_outline),
                  ),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person),
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 3
                          ? Colors.grey[100]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_travel_outlined),
                  ),
                  activeIcon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_travel),
                  ),
                  label: 'cart',
                )
              ],
            ),

          ),
        ),
      );
    });
  }
}