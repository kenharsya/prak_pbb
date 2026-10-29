import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import 'detail_screen.dart';
import 'product_card.dart';
import 'search_field.dart';
import 'state_views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _api.getProducts();
      if (!mounted) return;
      setState(() {
        _products = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat produk';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.trim().isEmpty) {
        _loadProducts();
        return;
      }
      
      if (!mounted) return; 
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      try {
        final result = await _api.searchProducts(query.trim());
        if (!mounted) return;
        setState(() {
          _products = result;
          _isLoading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _error = 'Gagal mencari produk';
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Novel')),
      body: Column(
        children: [
          SearchField(controller: _controller, onChanged: _onSearchChanged),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _loadProducts);
    if (_products.isEmpty) return const EmptyView();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        // Memilih warna pastel secara berurutan berdasarkan nomor index
        final color = AppColors.pastelCards[index % AppColors.pastelCards.length];
        
        return ProductCard(
          product: product,
          cardColor: color, // Mengirim warna ke dalam kartu
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
}