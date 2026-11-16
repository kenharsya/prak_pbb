import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_card.dart';
import 'product_form_screen.dart';
import 'search_field.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Product> displayedParts = [];
  bool isLoading = true;
  String? errorMessage;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final parts = await _apiService.getProducts();
      if (!mounted) return;
      setState(() {
        displayedParts = parts;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Tidak dapat terhubung ke server.\nPastikan backend berjalan: node backend/server.js\n\n$e';
      });
    }
  }

  Future<void> _onSearchChanged(String query) async {
    _query = query;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final results = await _apiService.searchProducts(query);
      if (!mounted) return;
      setState(() {
        displayedParts = results;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mencari: $e';
      });
    }
  }

  Future<void> _openForm({Product? product}) async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (context) => ProductFormScreen(product: product)),
    );
    if (result == null) return;
    try {
      if (product == null) {
        await _apiService.createProduct(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Part berhasil ditambahkan')),
          );
        }
      } else {
        await _apiService.updateProduct(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Part berhasil diperbarui')),
          );
        }
      }
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Part'),
        content: Text('Yakin ingin menghapus "${product.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _apiService.deleteProduct(product.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${product.title}" dihapus')),
        );
      }
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'Katalog Part Motor',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFB5EAD7),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF85C9A8),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchField(onChanged: _onSearchChanged),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                                const SizedBox(height: 12),
                                Text(errorMessage!, textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                ElevatedButton(onPressed: _loadData, child: const Text('Coba Lagi')),
                              ],
                            ),
                          ),
                        )
                      : displayedParts.isEmpty
                          ? Center(
                              child: Text(_query.isEmpty
                                  ? 'Belum ada part motor. Tekan "Tambah" untuk membuat.'
                                  : 'Part motor tidak ditemukan'),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadData,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.62,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: displayedParts.length,
                                itemBuilder: (context, index) {
                                  final product = displayedParts[index];
                                  return ProductCard(
                                    product: product,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(product: product),
                                        ),
                                      );
                                      _loadData();
                                    },
                                    onEdit: () => _openForm(product: product),
                                    onDelete: () => _deleteProduct(product),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
