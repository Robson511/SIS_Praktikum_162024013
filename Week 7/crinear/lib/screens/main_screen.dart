/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import '../repositories/product_repository.dart';
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

  // Id produk lokal sama dengan id produk di DummyJSON (1-4)
  final List<Product> _productList = [
    const Product(
      id: 1,
      title: 'Essence Mascara Lash Princess',
      price: 9.99,
      description:
          'The Essence Mascara Lash Princess is a popular mascara known for '
          'its volumizing and lengthening effects.',
      thumbnail:
          'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp',
    ),
    const Product(
      id: 2,
      title: 'Eyeshadow Palette with Mirror',
      price: 19.99,
      description:
          'The Eyeshadow Palette with Mirror offers a versatile range of '
          'eyeshadow shades for creating stunning eye looks.',
      thumbnail:
          'https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/thumbnail.webp',
    ),
    const Product(
      id: 3,
      title: 'Powder Canister',
      price: 14.99,
      description:
          'The Powder Canister is a finely milled setting powder designed to '
          'set makeup and control shine.',
      thumbnail:
          'https://cdn.dummyjson.com/product-images/beauty/powder-canister/thumbnail.webp',
    ),
    const Product(
      id: 4,
      title: 'Red Lipstick',
      price: 12.99,
      description:
          'The Red Lipstick is a classic and bold choice for adding a pop of '
          'color to your lips.',
      thumbnail:
          'https://cdn.dummyjson.com/product-images/beauty/red-lipstick/thumbnail.webp',
    ),
  ];

  void _addProduct(Product newProduct) {
    setState(() {
      // DummyJSON selalu memberi id yang sama untuk produk baru,
      // jadi id diganti agar tidak bentrok dengan produk lain di list
      final isUsed = _productList.any((p) => p.id == newProduct.id);
      _productList.add(
        isUsed ? newProduct.copyWith(id: _nextLocalId()) : newProduct,
      );
    });
  }

  int _nextLocalId() {
    int maxId = ProductRepository.lastServerId;
    for (final product in _productList) {
      if (product.id > maxId) maxId = product.id;
    }
    return maxId + 1;
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

  void _deleteProduct(int id) {
    setState(() {
      _productList.removeWhere((product) => product.id == id);
      _cartItems.removeWhere((item) => item.product.id == id);
    });
  }

  void _navigateToAddPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(onAdd: _addProduct),
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, Product productToEdit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          existingProduct: productToEdit,
          onSave: _updateProduct,
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

  void _removeFromCart(int productId) {
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
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: Color(0xFFF7931E)),
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
