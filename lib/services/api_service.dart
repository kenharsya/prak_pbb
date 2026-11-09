import 'dart:async';
import '../models/novel.dart';

class ApiService {
  final List<Novel> _novels = [
    Novel(
      id: '1',
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      genre: 'Drama / Edukasi',
      description: 'Kisah 10 anak dari keluarga miskin di Belitung yang berjuang menuntut ilmu di sekolah Muhammadiyah.',
      price: 85000,
      coverUrl: 'https://picsum.photos/seed/novel1/500/500',
    ),
    Novel(
      id: '2',
      title: 'Bumi Manusia',
      author: 'Pramoedya Ananta Toer',
      genre: 'Fiksi Sejarah',
      description: 'Kisah perjuangan Minke di era kolonial Belanda dalam mempertahankan hak dan cintanya.',
      price: 115000,
      coverUrl: 'https://picsum.photos/seed/novel2/500/500',
    ),
    Novel(
      id: '3',
      title: 'Hujan',
      author: 'Tere Liye',
      genre: 'Sci-Fi / Romantis',
      description: 'Menceritakan tentang persahabatan, cinta, dan kepasrahan di dunia masa depan pasca bencana dahsyat.',
      price: 90000,
      coverUrl: 'https://picsum.photos/seed/novel3/500/500',
    ),
    Novel(
      id: '4',
      title: 'Cantik Itu Luka',
      author: 'Eka Kurniawan',
      genre: 'Realisme Magis',
      description: 'Perpaduan antara sejarah kolonialisme, tragedi keluarga, dan elemen realisme magis khas Indonesia.',
      price: 110000,
      coverUrl: 'https://picsum.photos/seed/novel4/500/500',
    ),
    Novel(
      id: '5',
      title: 'Perahu Kertas',
      author: 'Dee Lestari',
      genre: 'Romantis / Remaja',
      description: 'Kisah persahabatan dan pencarian jati diri antara Kugy yang unik dan Keenan yang bercita-cita menjadi pelukis.',
      price: 88000,
      coverUrl: 'https://picsum.photos/seed/novel5/500/500',
    ),
    Novel(
      id: '6',
      title: 'Laut Bercerita',
      author: 'Leila S. Chudori',
      genre: 'Fiksi Sejarah',
      description: 'Mengangkat kisah penangkapan dan penghilangan paksa aktivis mahasiswa di era Orde Baru.',
      price: 105000,
      coverUrl: 'https://picsum.photos/seed/novel6/500/500',
    ),
  ];

  // READ (Get All)
  Future<List<Novel>> getNovels() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_novels);
  }

  // CREATE (Add New)
  Future<bool> addNovel(Novel novel) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _novels.add(novel);
    return true;
  }

  // UPDATE (Edit Existing)
  Future<bool> updateNovel(Novel novel) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _novels.indexWhere((n) => n.id == novel.id);
    if (index != -1) {
      _novels[index] = novel;
      return true;
    }
    return false;
  }

  // DELETE (Remove)
  Future<bool> deleteNovel(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _novels.removeWhere((n) => n.id == id);
    return true;
  }

  // SEARCH
  Future<List<Novel>> searchNovels(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return List.from(_novels);
    final q = query.toLowerCase();
    return _novels.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.author.toLowerCase().contains(q) ||
          n.genre.toLowerCase().contains(q);
    }).toList();
  }
}