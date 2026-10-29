/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program Warung IS
*/

import 'drink.dart';

class CartItem {
  final Drink drink;
  int quantity;

  CartItem({
    required this.drink,
    this.quantity = 1,
  });
}
