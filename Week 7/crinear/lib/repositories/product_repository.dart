/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'dart:io';

import 'package:dio/dio.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';

/// Perantara antara halaman (UI) dan ApiService, sekaligus tempat error handling
class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService(DioClient.createDio());

  /// DummyJSON hanya menyimpan produk id 1-194. Produk hasil tambah tidak
  /// benar-benar tersimpan, jadi produk dengan id di atas ini hanya ada di list lokal.
  static const int lastServerId = 194;

  static bool isLocalOnly(int id) => id > lastServerId;

  Future<Product> getProductDetail(int id) async {
    try {
      return await _apiService.getProduct(id);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Product> createProduct({
    required String title,
    required double price,
    required String description,
    required String thumbnail,
  }) async {
    try {
      final newProduct = Product(
        id: 0, // id baru ditentukan oleh server
        title: title,
        price: price,
        description: description,
        thumbnail: thumbnail,
      );
      return await _apiService.createProduct(newProduct);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      return await _apiService.updateProduct(product.id, product);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Menerjemahkan DioException menjadi pesan Bahasa Indonesia
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi ke server terlalu lama (timeout). Coba lagi nanti.';
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return 'Data yang dikirim tidak valid (400).';
          case 401:
            return 'Akses ditolak, perlu login (401).';
          case 404:
            return 'Produk tidak ditemukan di server (404).';
          case 500:
            return 'Server sedang bermasalah (500).';
          default:
            return 'Server membalas dengan status ${error.response?.statusCode}.';
        }
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      default:
        if (error.error is SocketException) {
          return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
        }
        return 'Terjadi kesalahan jaringan.';
    }
  }
}
