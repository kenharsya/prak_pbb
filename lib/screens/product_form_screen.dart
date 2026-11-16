import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product; // null = tambah, terisi = edit

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _brand;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _thumbnail;
  late final TextEditingController _category;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _brand = TextEditingController(text: p?.brand ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(text: p != null ? p.price.toString() : '');
    _thumbnail = TextEditingController(text: p?.thumbnail ?? '');
    _category = TextEditingController(text: p?.category ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _brand.dispose();
    _description.dispose();
    _price.dispose();
    _thumbnail.dispose();
    _category.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final product = Product(
      id: widget.product?.id ?? 0,
      title: _title.text.trim(),
      brand: _brand.text.trim(),
      description: _description.text.trim(),
      price: double.tryParse(_price.text.replaceAll(',', '.')) ?? 0,
      thumbnail: _thumbnail.text.trim(),
      category: _category.text.trim().isEmpty
          ? 'Lainnya'
          : _category.text.trim(),
    );
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Part Motor' : 'Tambah Part Motor',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFB5EAD7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Nama Part',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama part wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _brand,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Brand wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Harga (USD)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final parsed = double.tryParse(
                    (v ?? '').replaceAll(',', '.'),
                  );
                  if (parsed == null) return 'Harga harus berupa angka';
                  if (parsed < 0) return 'Harga tidak boleh negatif';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thumbnail,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: Icon(_isEditing ? Icons.save : Icons.add),
                  label: Text(_isEditing ? 'Simpan Perubahan' : 'Tambah Part'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF85C9A8),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
