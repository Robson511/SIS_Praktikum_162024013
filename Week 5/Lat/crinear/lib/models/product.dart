/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

class Product {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String category; // IEM atau DAC
  final String driver; // driver (IEM) atau chip (DAC), contoh: 1DD + 4BA
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.category = 'Lainnya',
    this.driver = '-',
    this.description = '',
  });
}
