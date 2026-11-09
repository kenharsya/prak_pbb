import 'package:flutter/material.dart';
import '../models/novel.dart';
import '../services/api_service.dart';
import 'novel_card.dart';
import 'search_field.dart';
import 'detail_screen.dart';
import 'form_novel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Novel> displayedNovels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final novels = await _apiService.getNovels();
    setState(() {
      displayedNovels = novels;
      isLoading = false;
    });
  }

  void _onSearchChanged(String query) async {
    setState(() => isLoading = true);
    final results = await _apiService.searchNovels(query);
    setState(() {
      displayedNovels = results;
      isLoading = false;
    });
  }

  void _addNovel() async {
    final newNovel = await Navigator.push<Novel>(
      context,
      MaterialPageRoute(builder: (context) => const FormNovelScreen()),
    );

    if (newNovel != null) {
      setState(() => isLoading = true);
      await _apiService.addNovel(newNovel);
      _loadData();
    }
  }

  void _updateNovel(Novel novel) async {
    setState(() => isLoading = true);
    await _apiService.updateNovel(novel);
    _loadData();
  }

  void _deleteNovel(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Novel'),
        content: const Text('Apakah Anda yakin ingin menghapus novel ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => isLoading = true);
      await _apiService.deleteNovel(id);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'Katalog Novel',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFB5EAD7),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB5EAD7),
        onPressed: _addNovel,
        child: const Icon(Icons.add, color: Colors.black87),
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
                  : displayedNovels.isEmpty
                      ? const Center(child: Text('Novel tidak ditemukan'))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: displayedNovels.length,
                          itemBuilder: (context, index) {
                            final novel = displayedNovels[index];
                            return NovelCard(
                              novel: novel,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      novel: novel,
                                      onUpdate: _updateNovel,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () => _deleteNovel(novel.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}