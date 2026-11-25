/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

/// Model Product mengikuti struktur data produk dari DummyJSON
@JsonSerializable()
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.description = '',
    this.thumbnail = '',
  });

  /// Deserialisasi: Map hasil JSON dari server menjadi objek Product
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Serialisasi: objek Product menjadi Map untuk dikirim sebagai JSON
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// Membuat salinan Product dengan sebagian nilai yang diganti
  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? thumbnail,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
