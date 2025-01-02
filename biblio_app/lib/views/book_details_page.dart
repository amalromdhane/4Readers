/*import 'package:biblio_app/views/listeEmpruntes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BookDetailsPage extends StatelessWidget {
  final String bookId;

  BookDetailsPage({required this.bookId});

  Future<Map<String, dynamic>> fetchBookDetails() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/books/$bookId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  // Fonction pour emprunter le livre
  Future<void> borrowBook(BuildContext context, String bookId, String userId) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/books/borrow/$bookId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'borrowed': true,
        'borrowDate': DateTime.now().toIso8601String(),
        'borrowedBy': userId,  // ID de l'utilisateur qui emprunte le livre
        'returnDate': DateTime.now().add(Duration(days: 7)).toIso8601String(),  // Retour dans 7 jours
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Afficher un message de succès
      _showDialog(context, 'Succès', 'Livre emprunté avec succès!');
    } else {
      // Afficher un message d'erreur si le livre est déjà emprunté
      _showDialog(context, 'Erreur', responseData['message']);
    }
  }

  // Fonction pour afficher un AlertDialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBookDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final book = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Affichage de l'image à gauche
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/${book['cover']}',
                          width: 150, // Largeur de l'image
                          height: 200, // Hauteur de l'image
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16), // Espacement entre l'image et le texte
                      // Informations du livre à droite
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Author: ${book['author']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Year: ${book['year']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Description: ${book['description']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Bouton d'emprunt
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      final userId = "userIdExample";  // Remplacez par l'ID de l'utilisateur réel
                      borrowBook(context, book['_id'], userId);
                    },
                    child: Text('Emprunter ce livre'),
                  ),
                  // Ajouter un bouton pour naviguer vers la liste des emprunts
                 
                ],
              ),
            );
          }
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookDetailsPage extends StatelessWidget {
  final String bookId;

  BookDetailsPage({required this.bookId});

  Future<Map<String, dynamic>> fetchBookDetails() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/books/$bookId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  // Fonction pour emprunter le livre
  Future<void> borrowBook(BuildContext context, String bookId, String userId) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/books/borrow/$bookId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'borrowed': true,
        'borrowDate': DateTime.now().toIso8601String(),
        'borrowedBy': userId,
        'returnDate': DateTime.now().add(Duration(days: 7)).toIso8601String(),  // Retour dans 7 jours
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Afficher un message de succès
      _showDialog(context, 'Succès', 'Livre emprunté avec succès!');
    } else {
      // Afficher un message d'erreur si le livre est déjà emprunté
      _showDialog(context, 'Erreur', responseData['message']);
    }
  }

  // Fonction pour afficher un AlertDialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0), // Beige clair
      appBar: AppBar(
        title: Text('Book Details'),
        backgroundColor: const Color.fromARGB(255, 227, 184, 143),
  titleSpacing: 0,
  elevation: 0,
       
        toolbarHeight: 50.0, 
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBookDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final book = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/${book['cover']}',
                              width: 150, 
                              height: 230, 
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16), 
                        
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title'],
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 227, 184, 143),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Author: ${book['author']}',
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Year: ${book['year']}',
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Description: ${book['description']}',
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                 
                  Positioned(
                    bottom: 350,
                    right: 42,
                    child: Column(
                      children: [
                      
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 227, 184, 143), 
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            textStyle: TextStyle(fontSize: 14),
                             foregroundColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                          onPressed: () {
                            final userId = "userIdExample";  
                            borrowBook(context, book['_id'], userId);
                          },
                          child: Text('Emprunter ce livre'),
                        ),
                      
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
