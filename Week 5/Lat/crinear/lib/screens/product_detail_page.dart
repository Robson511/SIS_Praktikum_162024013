/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/formatter.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Function(Product, int) onAddToCart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _showSuccessDialog(
    BuildContext context,
    String productName,
    int quantity,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil Ditambahkan'),
          content: Text(
            'Anda telah menambahkan $productName ($quantity) ke keranjang.',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF7931E),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: Colors.white,
        title: Text(widget.product.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProductInfoCard(product: widget.product),
            const SizedBox(height: 30),
            const Text('Jumlah:', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: _decrementQuantity,
                  iconSize: 40,
                  color: const Color(0xFF131313),
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _incrementQuantity,
                  iconSize: 40,
                  color: const Color(0xFFF7931E),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7931E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Tambah ke Keranjang',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                widget.onAddToCart(widget.product, _quantity);
                _showSuccessDialog(context, widget.product.name, _quantity);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductInfoCard extends StatelessWidget {
  final Product product;

  const ProductInfoCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              product.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Harga: ${formatRupiah(product.price)}',
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFD97706),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
