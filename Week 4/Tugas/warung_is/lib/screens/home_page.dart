/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program Warung IS
*/

import 'package:flutter/material.dart';

import '../models/drink.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final Function(Drink, int) onAddToCart;
  final void Function() onAdd;
  final void Function(Drink) onEdit;
  final void Function(String) onDelete;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showQuickAddDialog(String foodName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$foodName telah ditambahkan ke keranjang.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteDialog(Drink drink) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus ${drink.name}?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
            onPressed: () {
              widget.onDelete(drink.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.drinkList
        .where((drink) => drink.name.toLowerCase().contains(searchText))
        .toList();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Warung IS - Menu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Cari minuman favoritmu...',
              elevation: const WidgetStatePropertyAll(2),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              leading: const Icon(Icons.search, color: Colors.brown),
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
                final drink = filteredList[index];
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
                        widget.onAddToCart(drink, 1);
                        _showQuickAddDialog(drink.name);
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
                                color: Colors.brown[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                drink.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, err, stack) => const Icon(
                                  Icons.broken_image,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drink.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${drink.price}',
                                    style: const TextStyle(
                                      color: Colors.brown,
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
                                  tooltip: 'Detail',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DrinkDetailPage(
                                          drink: drink,
                                          onAddToCart: widget.onAddToCart,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // UPDATE
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  tooltip: 'Edit',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    widget.onEdit(drink);
                                  },
                                ),
                                // DELETE
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Hapus',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    _showDeleteDialog(drink);
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
