import 'package:flutter/material.dart';
import '../models/novel.dart';
import 'form_novel_screen.dart';

class DetailScreen extends StatelessWidget {
  final Novel novel;
  final Function(Novel) onUpdate;

  const DetailScreen({super.key, required this.novel, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: Text(novel.title),
        backgroundColor: const Color(0xFFB5EAD7),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () async {
              final updatedNovel = await Navigator.push<Novel>(
                context,
                MaterialPageRoute(
                  builder: (context) => FormNovelScreen(novel: novel),
                ),
              );

              if (updatedNovel != null) {
                onUpdate(updatedNovel);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              novel.coverUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: const Color(0xFFB5EAD7),
                child: const Icon(Icons.menu_book, size: 80, color: Colors.teal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    novel.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Penulis: ${novel.author}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.teal),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Genre: ${novel.genre}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${novel.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sinopsis:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(novel.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}