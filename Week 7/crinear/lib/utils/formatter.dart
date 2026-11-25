/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

/// Mengubah harga dari API (dolar) menjadi teks, contoh: 9.99 -> "$9.99"
String formatPrice(double value) {
  return '\$${value.toStringAsFixed(2)}';
}
