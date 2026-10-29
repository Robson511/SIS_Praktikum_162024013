/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program Warung IS
*/

import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(String) onRemoveFromCart;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.onCheckout,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _mejaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }

  int _getTotalPrice() {
    int total = 0;
    for (var item in widget.cartItems) {
      total += item.drink.price * item.quantity;
    }
    return total;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama Pemesan tidak boleh kosong';
    }
    return null;
  }

  String? _validateTable(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor Meja tidak boleh kosong';
    }
    final tableNumber = int.tryParse(value.trim());
    if (tableNumber == null) {
      return 'Nomor Meja harus berupa angka';
    }
    if (tableNumber < 1 || tableNumber > 20) {
      return 'Nomor Meja harus antara 1-20';
    }
    return null;
  }

  void _handleCheckout(int total) {
    if (_formKey.currentState!.validate()) {
      _showCheckoutDialog(
        total,
        _namaController.text.trim(),
        _mejaController.text.trim(),
      );
    }
  }

  void _showCheckoutDialog(int total, String name, String table) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout Berhasil'),
          content: Text(
            'Pesanan atas nama $name di meja $table berhasil dibuat '
            'dengan total belanja: Rp $total',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _namaController.clear();
                _mejaController.clear();
                widget.onCheckout();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _getTotalPrice();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Keranjang Anda')),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Keranjang Anda kosong, silahkan pesan terlebih dahulu.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        leading: Image.asset(
                          item.drink.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.local_cafe, size: 50),
                        ),
                        title: Text(item.drink.name),
                        subtitle: Text(
                          '${item.quantity} x Rp ${item.drink.price}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Rp ${item.drink.price * item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                widget.onRemoveFromCart(item.drink.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _namaController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Pemesan',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _mejaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nomor Meja',
                            hintText: '1-20',
                            prefixIcon: Icon(Icons.table_restaurant_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateTable,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Rp $total',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _handleCheckout(total);
                            },
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
