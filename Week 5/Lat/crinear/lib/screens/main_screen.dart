/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'add_product.dart';
import 'edit_product.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<CartItem> _cartItems = [];

  final List<Product> _productList = [
    const Product(
      id: 'p1',
      name: 'CrinEar Reference',
      price: 2199000,
      imageUrl: 'assets/reference.png',
      category: 'IEM',
      driver: '1DD + 4BA',
      description:
          'Tuning netral dan jujur untuk mendengar musik apa adanya. '
          'Cocok untuk monitoring, mixing, maupun audiophile yang '
          'mencari suara paling akurat.',
    ),
    const Product(
      id: 'p2',
      name: 'CrinEar NightFall',
      price: 1499000,
      imageUrl: 'assets/nightfall.png',
      category: 'IEM',
      driver: 'Dual Dynamic Driver',
      description:
          'Karakter hangat dan gelap dengan bass yang dalam dan tebal. '
          'Teman setia untuk sesi dengar santai di malam hari.',
    ),
    const Product(
      id: 'p3',
      name: 'CrinEar Daybreak',
      price: 999000,
      imageUrl: 'assets/daybreak.png',
      category: 'IEM',
      driver: '1DD + 2BA',
      description:
          'Suara cerah dan energik dengan vokal yang maju dan treble '
          'yang berkilau. Bikin semangat dari pagi hari.',
    ),
    const Product(
      id: 'p4',
      name: 'CrinEar Protocol',
      price: 1799000,
      imageUrl: 'assets/protocol.png',
      category: 'DAC',
      driver: 'Dual DAC 32-bit/384kHz',
      description:
          'DAC/amp portabel dengan output 3.5mm dan 4.4mm balanced. '
          'Tenaga besar untuk menghidupkan IEM maupun headphone.',
    ),
  ];

  void _addProduct(Product newProduct) {
    setState(() {
      _productList.add(newProduct);
    });
  }

  void _updateProduct(Product updatedProduct) {
    setState(() {
      final index = _productList.indexWhere(
        (product) => product.id == updatedProduct.id,
      );
      if (index != -1) {
        _productList[index] = updatedProduct;
      }
    });
  }

  void _deleteProduct(String id) {
    setState(() {
      _productList.removeWhere((product) => product.id == id);
    });
  }

  void _navigateToAddPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  void _navigateToEditPage(BuildContext context, Product productToEdit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          existingProduct: productToEdit,
          onSave: (Product updatedProduct) {
            _updateProduct(updatedProduct);
          },
        ),
      ),
    );
  }

  void _addToCart(Product product, int quantity) {
    setState(() {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (index != -1) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(product: product, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  List<Widget> _buildPages() {
    return [
      HomePage(
        productList: _productList,
        onAddToCart: _addToCart,
        onAdd: () {
          _navigateToAddPage(context);
        },
        onEdit: (Product product) {
          _navigateToEditPage(context, product);
        },
        onDelete: _deleteProduct,
      ),
      CartPage(
        cartItems: _cartItems,
        onRemoveFromCart: _removeFromCart,
        onCheckout: _clearCart,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    int totalItem = 0;
    for (var item in _cartItems) {
      totalItem += item.quantity;
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFF2F2F2),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.headphones_outlined),
            selectedIcon: Icon(Icons.headphones, color: Color(0xFFF7931E)),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: totalItem > 0,
              label: Text('$totalItem'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: totalItem > 0,
              label: Text('$totalItem'),
              child: const Icon(Icons.shopping_bag, color: Color(0xFFF7931E)),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
