import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import 'orders_history_page.dart';
import 'product_view.dart';
import 'profile_page.dart';

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

    switch (index) {
      case 0:
        Get.to(() => HomePage());
        break;
      case 1:
        Get.to(() => ProductPage()); // Navigate to ProductView for search/products
        break;
      case 2:
        Get.to(() => OrderHistoryView());
        break;
      case 3:
        Get.to(() => ProfilePage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildBanner(),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF3E3E3E)],
          ),
        ),
      ),
      leading: _buildProfileAvatar(),
      title: _buildAppBarTitle(),
      actions: [_buildLogoutButton()],
    );
  }

  Widget _buildProfileAvatar() {
    return Padding(
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
                ? const Icon(Icons.person, color: Colors.white70)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sneaker Store',
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
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
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
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: PageView(
        children: [
          _buildBannerItem(),
        ],
      ),
    );
  }

  Widget _buildBannerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -40,
            top: -70,
            child: Transform.rotate(
              angle: -0.6,
              child: Image.asset(
                'assets/images/sneaker.png',
                height: 340,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.sports_soccer,
                  size: 100,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
          _buildBannerContent(),
        ],
      ),
    );
  }

  Widget _buildBannerContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'New Arrival',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(
            'Nike Air Max 2024',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Starting from \$199',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Shop Now',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
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
        onTap: _onItemTapped,
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
        items: _buildNavItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
      _buildNavItem(1, Icons.search_outlined, Icons.search, 'Search'),
      _buildNavItem(2, Icons.receipt_long_sharp, Icons.history_edu, 'Orders'),
      _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
    ];
  }

  BottomNavigationBarItem _buildNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }
}