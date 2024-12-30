import 'package:flutter/material.dart';
import 'package:sneakerstore_client/pages/product_description_page.dart';
import 'package:sneakerstore_client/widget/drop_down_buton.dart';
import 'package:sneakerstore_client/widget/multi_select_drop_down.dart';

import '../widget/product_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Sneaker Store',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.black54),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Chip(
                    label: const Text(
                      'Category',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropDownBtn(
                      items: const ['Giá cao đến thấp', 'Giá Thấp đến cao'],
                      selectedItemText: 'Lọc theo giá',
                      onSelected: (selected) {},
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: MultiSelectDropDown(
                      items: ['item1', 'item2', 'item3'],
                      onSelectionChanged: (selectedItems) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ProductWidget(
                  name: 'Adidas Sambba',
                  imageUrl:
                  'https://cdn.evrysz.net/1000x1000/1/adidas-samba-og-ji3215.png',
                  price: 200,
                  offer: '30% off',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductDescriptionPage(
                   )
                    ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}