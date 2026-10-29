/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int _getTotalPrice() {
    int total = 0;
    for (var item in widget.cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama Pemesan tidak boleh kosong';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor Telepon tidak boleh kosong';
    }
    final phone = value.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Nomor Telepon harus berupa angka';
    }
    if (phone.length < 10 || phone.length > 13) {
      return 'Nomor Telepon harus 10-13 digit';
    }
    return null;
  }

  void _handleCheckout(int total) {
    if (_formKey.currentState!.validate()) {
      _showCheckoutDialog(
        total,
        _namaController.text.trim(),
        _phoneController.text.trim(),
      );
    }
  }

  void _showCheckoutDialog(int total, String name, String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout Berhasil'),
          content: Text(
            'Pesanan atas nama $name ($phone) berhasil dibuat '
            'dengan total belanja: Rp $total',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF7931E),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _namaController.clear();
                _phoneController.clear();
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF131313),
        foregroundColor: Colors.white,
        title: const Text('Keranjang Anda'),
      ),
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
                          item.product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.headphones,
                                size: 50,
                                color: Color(0xFFF7931E),
                              ),
                        ),
                        title: Text(item.product.name),
                        subtitle: Text(
                          '${item.quantity} x Rp ${item.product.price}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${item.product.price * item.quantity}',
                              style: const TextStyle(color: Color(0xFFD97706)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                widget.onRemoveFromCart(item.product.id);
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
                  color: const Color(0xFFF2F2F2),
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
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Nomor Telepon',
                            hintText: 'contoh: 081234567890',
                            prefixIcon: Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: _validatePhone,
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
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF7931E),
                              foregroundColor: Colors.white,
                            ),
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
