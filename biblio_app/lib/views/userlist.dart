import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_drawer.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}


class _UserListState extends State<UserList> {

  Future<List<dynamic>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/users/user'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/users/$userId'),
    );
    if (response.statusCode == 200) {
      print('User supprimé avec succès');
    } else {
      print('Erreur lors de la suppression');
    }
  }

  
  void reloadusers() {
    setState(() {});
  }

  

  Future<void> updateUser(String userId, Map<String, String> updatedUserData) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/users/update/$userId'),
      body: jsonEncode(updatedUserData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Usermis à jour avec succès');
    } else {
      print('Erreur lors de la mise à jour');
    }
  }


 
  void showEditUserDialog(BuildContext context, String userId, String currentUsername, String currentPassword, String currentEmail, String currentRole) {
  final _titleController = TextEditingController(text: currentUsername);
  final _authorController = TextEditingController(text: currentPassword);
  final _yearController = TextEditingController(text: currentEmail);
  final _descriptionController = TextEditingController(text: currentRole);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Modifier l\'utilisateur'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
              ),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Rôle'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
             
              if (_titleController.text.isEmpty || _authorController.text.isEmpty || _yearController.text.isEmpty || _descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez remplir tous les champs')),
                );
                return;
              }

             
              Map<String, String> updatedUserData = {
                'username': _titleController.text,
                'password': _authorController.text,
                'email': _yearController.text,
                'role': _descriptionController.text,
              };

              updateUser(userId, updatedUserData).then((_) {
                reloadusers(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Utilisateur mis à jour avec succès')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la mise à jour : $error')),
                );
              });

              Navigator.of(context).pop(); 
            },
            child: Text('Sauvegarder'),
          ),
        ],
      );
    },
  );
}



  void showDeleteConfirmationDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce luser ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                deleteUser(userId).then((_) {
                  reloadusers(); 
                });
                Navigator.of(context).pop(); 
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
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final user = users[index];

                
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
                    ),
                    title: Text(
                      user['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'password: ${user['password']}',
      style: TextStyle(color: Colors.grey[600]),
    ),
    SizedBox(height: 4),  
    Text(
      'Email: ${user['email'].toString()}',
      style: TextStyle(color: Colors.grey[600]),
    ),
    SizedBox(height: 4),
    /*Text(
      'Description: ${user['role']}',
      style: TextStyle(color: Colors.grey[600]),
      maxLines: 2,  // Limiter la description à 2 lignes
      overflow: TextOverflow.ellipsis, // Ajouter des "..." si la description est trop longue
    ),*/
  ],
),

                   
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showEditUserDialog(
                              context,
                              user['_id'],
                              user['username'],
                              user['password'], 
                              user['email'],
                              user['role']
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDeleteConfirmationDialog(context, user['_id']);
                          },
                        ),
                      ],
                    ),
                    /*onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            userDetailsPage(userId: user['_id']),
                      ),
                    ),*/
                  ),
                );
              },
            );
          }
        },
      ),
     /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdduserForm()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),*/
    );
  }
}