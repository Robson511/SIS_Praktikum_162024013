/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program Warung IS
*/

import 'package:flutter/material.dart';

import '../models/drink.dart';
import '../models/cart_item.dart';
import 'home_page.dart';
import 'cart_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<CartItem> _cartItems = [];

  final List<Drink> _drinkList = const [
    Drink(
      id: 'd1',
      name: 'Americano',
      price: 20000,
      imageUrl: 'assets/Americano.png',
    ),
    Drink(id: 'd2', name: 'Latte', price: 25000, imageUrl: 'assets/Latte.png'),
    Drink(
      id: 'd3',
      name: 'Mont Blanc',
      price: 30000,
      imageUrl: 'assets/Mont Blanc.png',
    ),
    Drink(
      id: 'd4',
      name: 'Redbull',
      price: 15000,
      imageUrl: 'assets/Redbull.png',
    ),
  ];

  void _addToCart(Drink drink, int quantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.drink.id == drink.id);
      if (index != -1) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItem = 0;
    for (var item in _cartItems) {
      totalItem += item.quantity;
    }

    return Scaffold(
      body: _selectedIndex == 0
          ? HomePage(drinkList: _drinkList, onAddToCart: _addToCart)
          : CartPage(
              cartItems: _cartItems,
              onRemoveFromCart: _removeFromCart,
              onCheckout: _clearCart,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: totalItem > 0,
              label: Text('$totalItem'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
