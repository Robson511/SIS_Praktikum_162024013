/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../utils/formatter.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Product> productList;
  final Function(Product, int) onAddToCart;
  final void Function() onAdd;
  final void Function(Product) onEdit;
  final void Function(int) onDelete;

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

  final ProductRepository _repository = ProductRepository();
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

  /// Konfirmasi hapus, lalu DELETE /products/{id} ke DummyJSON
  void _showDeleteDialog(Product product) {
    bool isDeleting = false;
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Anda yakin ingin menghapus ${product.title}?'),
              if (errorText != null) ...[
                const SizedBox(height: 12),
                Text(errorText!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isDeleting
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: isDeleting
                  ? null
                  : () async {
                      setDialogState(() {
                        isDeleting = true;
                        errorText = null;
                      });
                      try {
                        // Produk hasil tambah tidak ada di server, cukup dihapus lokal
                        if (!ProductRepository.isLocalOnly(product.id)) {
                          await _repository.deleteProduct(product.id);
                        }
                        if (!dialogContext.mounted) return;
                        Navigator.of(dialogContext).pop();
                        widget.onDelete(product.id);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} berhasil dihapus.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() {
                          isDeleting = false;
                          errorText = e.toString().replaceFirst(
                            'Exception: ',
                            '',
                          );
                        });
                      }
                    },
              child: isDeleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.productList
        .where((product) => product.title.toLowerCase().contains(searchText))
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
              hintText: 'Cari produk...',
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
                        _showQuickAddDialog(product.title);
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
                                child: Image.network(
                                  product.thumbnail,
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, err, stack) => const Icon(
                                    Icons.image_not_supported_outlined,
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
                                    product.title,
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
                                    formatPrice(product.price),
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
