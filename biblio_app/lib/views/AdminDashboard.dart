import 'package:biblio_app/views/app_drawer.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 216, 176),
      appBar: AppBar(title: Text('AdminDash')),
      drawer: AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg5.png'), // Chemin vers votre image
            fit: BoxFit.cover,
          ),
        ),
      ), // <- Corrigé ici, remplacez ';' par ')'
    );
  }
}
