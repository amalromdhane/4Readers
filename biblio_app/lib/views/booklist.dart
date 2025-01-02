import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book_details_page.dart';
import 'app_drawer.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  // Fonction pour récupérer les livres depuis le backend
  Future<List<dynamic>> fetchBooks() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/books'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }

  // Fonction pour supprimer un livre
  Future<void> deleteBook(String bookId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/books/$bookId'),
    );
    if (response.statusCode == 200) {
      print('Livre supprimé avec succès');
    } else {
      print('Erreur lors de la suppression');
    }
  }

  // Fonction pour mettre à jour un livre
  Future<void> updateBook(String bookId, Map<String, String> updatedBookData) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/books/$bookId'),
      body: jsonEncode(updatedBookData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Livre mis à jour avec succès');
    } else {
      print('Erreur lors de la mise à jour');
    }
  }

  // Fonction pour recharger les livres après une suppression ou une mise à jour
  void reloadBooks() {
    setState(() {});
  }

  //formulaire de modification
  void showEditBookDialog(BuildContext context, String bookId, String currentTitle, String currentAuthor,int currentYear,String currentDescription) {
    final _titleController = TextEditingController(text: currentTitle);
    final _authorController = TextEditingController(text: currentAuthor);
   final _yearController = TextEditingController(text: currentYear.toString());

    final _descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le livre'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: 'Auteur'),
                ),
                TextField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'year'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue sans modifier
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Mettre à jour le livre avec les nouvelles données
                Map<String, String> updatedBookData = {
                  'title': _titleController.text,
                  'author': _authorController.text,
                  'year': _yearController.text,
                  'description': _descriptionController.text,
                };
                updateBook(bookId, updatedBookData).then((_) {
                  reloadBooks(); // Recharger les livres après la mise à jour
                });
                Navigator.of(context).pop(); // Fermer le dialogue après mise à jour
              },
              child: Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce livre ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                // Appeler la fonction de suppression
                deleteBook(bookId).then((_) {
                  reloadBooks(); // Recharger les livres après la suppression
                });
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(title: Text('Library')),
      drawer: AppDrawer(),
      body: FutureBuilder<List<dynamic>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final book = books[index];

                // Définir une couleur basée sur l'indice
                final cardColor = index % 2 == 0
                    ? const Color.fromRGBO(231, 216, 176, 1)// Couleur claire pour les indices pairs
                    : const Color.fromARGB(255, 229, 210, 159); // Couleur claire pour les indices impairs

                    /*final cardColor = index % 2 == 0
                    ? Colors.blue[50] // Couleur claire pour les indices pairs
                    : Colors.green[50]; // Couleur claire pour les indices impairs*/

                return Card(
                  color: cardColor,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/${book['cover']}',
                        width: 80,
                        height: 160,
                       
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    title: Text(
                      book['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Author: ${book['author']}',
      style: TextStyle(color: Colors.grey[600]),
    ),
    SizedBox(height: 4),  // Espacement entre les informations
    Text(
      'Year: ${book['year'].toString()}',
      style: TextStyle(color: Colors.grey[600]),
    ),
    SizedBox(height: 4),
    Text(
      'Description: ${book['description']}',
      style: TextStyle(color: Colors.grey[600]),
      maxLines: 2,  // Limiter la description à 2 lignes
      overflow: TextOverflow.ellipsis, // Ajouter des "..." si la description est trop longue
    ),
  ],
),

                   
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showEditBookDialog(
                              context,
                              book['_id'],
                              book['title'],
                              book['author'], 
                              book['year'],
                              book['description']
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDeleteConfirmationDialog(context, book['_id']);
                          },
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetailsPage(bookId: book['_id']),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}