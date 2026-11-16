import 'dart:convert';

import '../models/product.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  // - Web (Chrome): pakai localhost langsung
  // - Emulator Android: 10.0.2.2 = localhost komputer
  // - Perangkat fisik Android: ganti dengan IP LAN komputer, mis. 192.168.1.10
  static const String _host = kIsWeb ? 'localhost' : '10.0.2.2';
  static const String baseUrl = 'http://$_host:3000/products';

  Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat produk (${res.statusCode})');
    }
    final List data = jsonDecode(res.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {'q': query});
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Gagal mencari produk (${res.statusCode})');
    }
    final List data = jsonDecode(res.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> createProduct(Product product) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (res.statusCode != 201) {
      throw Exception('Gagal menambah produk (${res.statusCode})');
    }
    return Product.fromJson(jsonDecode(res.body));
  }

  Future<Product> updateProduct(Product product) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Gagal mengubah produk (${res.statusCode})');
    }
    return Product.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus produk (${res.statusCode})');
    }
  }
}
