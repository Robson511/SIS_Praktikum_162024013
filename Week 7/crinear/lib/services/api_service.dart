/*
Nama : Wibi Raouf Sutama
NRP  : 162024013
Program CrinEar - Toko IEM
*/

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/product.dart';

part 'api_service.g.dart';

/// Daftar endpoint produk DummyJSON yang dipakai aplikasi
@RestApi(baseUrl: 'https://dummyjson.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  /// Detail produk: GET https://dummyjson.com/products/{id}
  @GET('/products/{id}')
  Future<Product> getProduct(@Path('id') int id);

  /// Tambah produk: POST https://dummyjson.com/products/add
  @POST('/products/add')
  Future<Product> createProduct(@Body() Product product);

  /// Edit produk: PUT https://dummyjson.com/products/{id}
  @PUT('/products/{id}')
  Future<Product> updateProduct(@Path('id') int id, @Body() Product product);

  /// Hapus produk: DELETE https://dummyjson.com/products/{id}
  @DELETE('/products/{id}')
  Future<void> deleteProduct(@Path('id') int id);
}
