import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddBookForm extends StatefulWidget {
  @override
  _AddBookFormState createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _coverController = TextEditingController(); // Ajout du controller pour le cover

  // Fonction pour soumettre le formulaire
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    String url = 'http://localhost:3000/api/books';

    try {
      // Configuration des données de la requête
      var formData = {
        'title': _titleController.text,
        'author': _authorController.text,
        'year': _yearController.text,
        'description': _descriptionController.text,
        'cover': _coverController.text, // Envoi du chemin de l'image
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
          SnackBar(content: Text('Livre ajouté avec succès !')),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l’ajout du livre.')),
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
        title: Text('Add BOOK'),
        backgroundColor: const Color.fromARGB(255, 227, 200, 160),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titre du livre
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    labelStyle: TextStyle(color:  Color.fromARGB(255, 206, 176, 131)),
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
                      return 'Veuillez entrer le titre du livre.';
                    }
                    return null;
                  },
                ),
              ),

              // Auteur du livre
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Auteur',
                    labelStyle: TextStyle(color:  Color.fromARGB(255, 206, 176, 131)),
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
                      return 'Veuillez entrer l’auteur du livre.';
                    }
                    return null;
                  },
                ),
              ),

              // Année de publication
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: 'Année',
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
                      return 'Veuillez entrer l’année de publication.';
                    }
                    return null;
                  },
                ),
              ),

              // Description du livre
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                      return 'Veuillez entrer une description.';
                    }
                    return null;
                  },
                ),
              ),

              // URL de la couverture
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _coverController,
                  decoration: InputDecoration(
                    labelText: 'Couverture (URL)',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 206, 192, 116)),
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
                      return 'Veuillez entrer l\'URL de l\'image de couverture.';
                    }
                    return null;
                  },
                ),
              ),

              // Bouton d'ajout
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Ajouter le livre'),
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
