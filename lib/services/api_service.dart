import 'dart:async';
import '../models/product.dart';

class ApiService {
  final List<Product> _mockBooks = [
    Product(
      id: 1,
      title: 'Bumi Manusia',
      description: 'Kisah Minke dan Annelies di masa kolonial Belanda. Karya epik Pramoedya Ananta Toer yang membahas ketidakadilan dan perjuangan.',
      price: 12.50,
      // Menggunakan server Wikipedia (bebas blokir)
      thumbnail: 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEisLpcB_wbTE67RyzS3sd7px_W-KHwjRzKRa_uYJ1r1H54NCPBIWAL2WCZk9nIOvjjcU_tlszDuZRp0EyysAc9cMxMIj9XoD3iBy-09xtG3yiqgMHvg9gqz2tydudAwNZKDJ8dTdJnzfyc/s1600/1398034._UY1600_SS1600_.jpg',
      category: 'Novel Indonesia',
    ),
    Product(
      id: 2,
      title: 'The Great Gatsby',
      description: 'A story of the wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan. A classic critique of the American Dream.',
      price: 15.00,
      thumbnail: 'https://upload.wikimedia.org/wikipedia/commons/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg',
      category: 'English Novel',
    ),
    Product(
      id: 3,
      title: 'Laskar Pelangi',
      description: 'Perjuangan 10 anak desa di Belitung untuk mendapatkan pendidikan yang layak. Kisah inspiratif dan mengharukan karya Andrea Hirata.',
      price: 10.00,
      thumbnail: 'https://upload.wikimedia.org/wikipedia/id/8/8e/Laskar_pelangi_sampul.jpg',
      category: 'Novel Indonesia',
    ),
    Product(
      id: 4,
      title: 'To Kill a Mockingbird',
      description: 'Compassionate, dramatic, and deeply moving tale of a lawyer in the American South defending an innocent man.',
      price: 14.20,
      thumbnail: 'https://upload.wikimedia.org/wikipedia/commons/4/4f/To_Kill_a_Mockingbird_%28first_edition_cover%29.jpg',
      category: 'English Novel',
    ),
    Product(
      id: 5,
      title: 'Cantik Itu Luka',
      description: 'Kisah keluarga yang dipenuhi tragedi dan sejarah panjang Indonesia yang dibalut realisme magis. Karya Eka Kurniawan.',
      price: 16.50,
      thumbnail: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&q=80',
      category: 'Novel Indonesia',
    ),
    Product(
      id: 6,
      title: '1984',
      description: 'A dystopian social science fiction novel and cautionary tale about the dangers of totalitarianism and mass surveillance.',
      price: 11.99,
      thumbnail: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh6FZOl6eyomXYpro1-CMzBSKVn5i-GXlo05c0zzJZXe3yocdi0BWoykAk&s=10',
      category: 'English Novel',
    ),
    Product(
      id: 7,
      title: 'Hujan',
      description: 'Novel tentang persahabatan, cinta, dan perpisahan berlatar masa depan ketika bumi mengalami bencana alam mematikan.',
      price: 13.00,
      // Menggunakan server OpenLibrary (Database buku gratis)
      thumbnail: 'https://covers.openlibrary.org/b/isbn/9786020324784-L.jpg',
      category: 'Novel Indonesia',
    ),
    Product(
      id: 8,
      title: 'Atomic Habits',
      description: 'An easy and proven way to build good habits and break bad ones. Practical strategies for daily improvement.',
      price: 18.50,
      thumbnail: 'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg',
      category: 'English Self-Help',
    ),
  ];

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockBooks;
  }

  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBooks.where((book) => 
        book.title.toLowerCase().contains(query.toLowerCase()) || 
        book.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}