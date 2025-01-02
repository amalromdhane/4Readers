/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Modèle de données pour un livre
class Book {
  final String title;
  final String author;
  final String cover;
  final String borrowDate;
  final String returnDate;

  Book({
    required this.title,
    required this.author,
    required this.cover,
    required this.borrowDate,
    required this.returnDate,
  });

  // Fonction pour convertir la réponse JSON en objet Book
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      cover: json['cover'],
      borrowDate: json['borrowDate'],
      returnDate: json['returnDate'],
    );
  }
}

class ListeEmpruntesPage extends StatefulWidget {
  @override
  _ListeEmpruntesPageState createState() => _ListeEmpruntesPageState();
}

class _ListeEmpruntesPageState extends State<ListeEmpruntesPage> {
  late Future<List<Book>> _books;

  // Récupérer la liste des livres empruntés
  Future<List<Book>> fetchBooks(String userId) async {
    final String url = 'http://localhost:3000/api/books/borrowedBy/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des livres');
      }
    } catch (e) {
      throw Exception('Erreur de réseau: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _books = fetchBooks('674b80f5acf482ccee6fd530');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livres Empruntés'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun livre emprunté.'));
          } else {
            List<Book> books = snapshot.data!;

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  leading: Image.asset('assets/${book.cover}'), 
                  title: Text(book.title),
                  subtitle: Text('Par: ${book.author}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Retour: ${book.returnDate}'),
                      Text('Emprunté le: ${book.borrowDate}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}*/import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpruntsPage extends StatelessWidget {
  final String userId;

  EmpruntsPage({required this.userId});

  // Fonction pour récupérer les emprunts de l'utilisateur
  Future<List<dynamic>> fetchEmprunts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/books/borrowedBy/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load emprunts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Emprunts'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchEmprunts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final emprunts = snapshot.data!;
            return ListView.builder(
              itemCount: emprunts.length,
              itemBuilder: (context, index) {
                final emprunt = emprunts[index];
                return ListTile(
                  title: Text(emprunt['book']['title']),
                  subtitle: Text('Emprunté le: ${emprunt['borrowDate']}'),
                  trailing: Text('Retour le: ${emprunt['returnDate']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
