/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/formatter.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Product> productList;
  final Function(Product, int) onAddToCart;
  final void Function() onAdd;
  final void Function(Product) onEdit;
  final void Function(String) onDelete;

  const HomePage({
    super.key,
    required this.productList,
    required this.onAddToCart,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Palet warna mengikuti logo CrinEar
  static const Color orange = Color(0xFFF7931E);
  static const Color darkOrange = Color(0xFFD97706);
  static const Color black = Color(0xFF131313);

  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showQuickAddDialog(String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName telah ditambahkan ke keranjang.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteDialog(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus ${product.name}?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
            onPressed: () {
              widget.onDelete(product.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.productList
        .where((product) => product.name.toLowerCase().contains(searchText))
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        foregroundColor: Colors.white,
        title: const Text(
          'CrinEar - Katalog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Cari IEM atau DAC...',
              elevation: const WidgetStatePropertyAll(2),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              leading: const Icon(Icons.search, color: orange),
              trailing: [
                if (searchText.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchText = '';
                      });
                    },
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final product = filteredList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      // Tap kartu = tambah 1 ke keranjang (sesuai modul)
                      onTap: () {
                        widget.onAddToCart(product, 1);
                        _showQuickAddDialog(product.name);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4E6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // Hero: gambar "terbang" ke halaman detail
                              child: Hero(
                                tag: 'product-${product.id}',
                                child: Image.asset(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, err, stack) => const Icon(
                                    Icons.headphones,
                                    color: orange,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatRupiah(product.price),
                                    style: const TextStyle(
                                      color: darkOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // READ (detail) -> Navigator.push + passing data
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  color: black,
                                  tooltip: 'Detail',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                          product: product,
                                          onAddToCart: widget.onAddToCart,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // UPDATE
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: orange,
                                  tooltip: 'Edit',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    widget.onEdit(product);
                                  },
                                ),
                                // DELETE
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  tooltip: 'Hapus',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    _showDeleteDialog(product);
                                  },
                                ),
                              ],
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
        ],
      ),
      // CREATE
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAdd,
        tooltip: 'Tambah Produk',
        backgroundColor: orange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
