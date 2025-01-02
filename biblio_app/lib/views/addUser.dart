import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  // Fonction pour soumettre le formulaire
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    String url = 'http://localhost:3000/api/users';

    try {
      // Configuration des données de la requête
      var formData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email':_emailController.text,
        'role': _roleController.text,
      };

      Dio dio = Dio();

      // Ajouter des en-têtes pour indiquer que c'est du JSON
      dio.options.headers = {
        'Content-Type': 'application/json',
      };

      // Effectuer la requête POST
      var response = await dio.post(url, data: formData);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ajouté avec succès !')),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l’ajout du User.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 219, 183),
      appBar: AppBar(
        title: Text('Add User'),
        backgroundColor: const Color.fromARGB(255, 227, 200, 160),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titre du User
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'username',
                    labelStyle: TextStyle(color:  const Color.fromARGB(255, 206, 176, 131)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le username.';
                    }
                    return null;
                  },
                ),
              ),

              // Auteur du User
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'password',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 206, 176, 131)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le password du User.';
                    }
                    return null;
                  },
                ),
              ),

              // Année de publication
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller:_emailController,
                  decoration: InputDecoration(
                    labelText: 'email',
                    labelStyle: TextStyle(color:   Color.fromARGB(255, 206, 176, 131)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  keyboardType: TextInputType.number, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le email de user.';
                    }
                    return null;
                  },
                ),
              ),

              // Description du User
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    labelText: 'role',
                    labelStyle: TextStyle(color:   Color.fromARGB(255, 206, 176, 131)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le role.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Ajouter le User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 216, 187, 142),
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
