import 'package:flutter/material.dart';
import '../models/novel.dart';

class FormNovelScreen extends StatefulWidget {
  final Novel? novel;

  const FormNovelScreen({super.key, this.novel});

  @override
  State<FormNovelScreen> createState() => _FormNovelScreenState();
}

class _FormNovelScreenState extends State<FormNovelScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _coverUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.novel?.title ?? '');
    _authorController = TextEditingController(text: widget.novel?.author ?? '');
    _genreController = TextEditingController(text: widget.novel?.genre ?? '');
    _priceController = TextEditingController(text: widget.novel?.price.toString() ?? '');
    _descController = TextEditingController(text: widget.novel?.description ?? '');
    _coverUrlController = TextEditingController(
      text: widget.novel?.coverUrl ?? 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/500/500',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final novel = Novel(
        id: widget.novel?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        genre: _genreController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descController.text.trim(),
        coverUrl: _coverUrlController.text.trim(),
      );

      Navigator.pop(context, novel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.novel != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Novel' : 'Tambah Novel Baru'),
        backgroundColor: const Color(0xFFB5EAD7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Novel'),
                validator: (val) => val == null || val.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (val) => val == null || val.isEmpty ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre / Kategori'),
                validator: (val) => val == null || val.isEmpty ? 'Genre wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                validator: (val) => val == null || val.isEmpty ? 'Harga wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Deskripsi / Sinopsis'),
                validator: (val) => val == null || val.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coverUrlController,
                decoration: const InputDecoration(labelText: 'URL Cover Gambar'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB5EAD7),
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _saveForm,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Novel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}