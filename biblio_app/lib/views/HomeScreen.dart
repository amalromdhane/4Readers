import 'package:biblio_app/views/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book_details_page.dart';

class HomePage extends StatelessWidget {
  // Fonction pour récupérer les livres depuis l'API
  Future<List<dynamic>> fetchBooks() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/books'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 216, 176),
      appBar: AppBar(
        title: Text('Library'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige vers la page de connexion
            );
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchBooks(), // Récupérer les livres
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Attente de la réponse
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Erreur
          } else {
            final books = snapshot.data!; // Liste des livres récupérée
            return ListView.builder(
              itemCount: (books.length / 3).ceil(), // Trois livres par ligne
              padding: const EdgeInsets.all(6.0),
              itemBuilder: (context, index) {
                // On récupère les trois livres pour chaque ligne
                final book1 = books[index * 3];
                final book2 = index * 3 + 1 < books.length ? books[index * 3 + 1] : null;
                final book3 = index * 3 + 2 < books.length ? books[index * 3 + 2] : null;

                final cardColor1 = index % 2 == 0 ? Colors.blue[50] : Colors.green[50];
                final cardColor2 = (index + 1) % 2 == 0 ? Colors.blue[50] : Colors.green[50];
                final cardColor3 = (index + 2) % 2 == 0 ? Colors.blue[50] : Colors.green[50];

                return Row(
                  children: [
                    // Première carte (book1)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            final bookId = book1['_id']; // _id du livre
                            if (bookId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(bookId: bookId), 
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Card(
                                color: cardColor1,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: book1['cover'] != null
                                      ? Image.asset(
                                          'assets/images/${book1['cover']}',
                                          width: 200, // Largeur fixe
                                          height: 180, // Hauteur fixe
                                          fit: BoxFit.fill,
                                        )
                                      : Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  book1['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Deuxième carte (book2)
                    if (book2 != null)
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              final bookId = book2['_id']; // _id du livre
                              if (bookId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsPage(bookId: bookId),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: cardColor2,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: book2['cover'] != null
                                        ? Image.asset(
                                            'assets/images/${book2['cover']}',
                                            width: 200, // Largeur fixe
                                            height: 180, // Hauteur fixe
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    book2['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // Troisième carte (book3)
                    if (book3 != null)
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              final bookId = book3['_id']; // _id du livre
                              if (bookId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsPage(bookId: bookId),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: cardColor3,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: book3['cover'] != null
                                        ? Image.asset(
                                            'assets/images/${book3['cover']}',
                                            width: 200, // Largeur fixe
                                            height: 180, // Hauteur fixe
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    book3['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
