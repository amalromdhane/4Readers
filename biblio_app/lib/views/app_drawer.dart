import 'package:biblio_app/views/LoginScreen.dart';
import 'package:biblio_app/views/addUser.dart';
import 'package:biblio_app/views/addbook.dart';
import 'package:biblio_app/views/booklist.dart';
import 'package:biblio_app/views/userlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:const Color.fromRGBO(231, 216, 176, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: const Color.fromRGBO(231, 216, 176, 1)),
            child: Text(
              'Library Menu',
              style: TextStyle(color: const Color.fromARGB(255, 243, 242, 241), fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Book List'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookList()),
          );
            },
          ),

          ListTile(
            leading: Icon(Icons.book),
            title: Text('ADD Book'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookForm()),
          );
            },
          ),

           ListTile(
            leading: Icon(Icons.book),
            title: Text('User List'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserList()),
          );
            },
          ),
           ListTile(
            leading: Icon(Icons.book),
            title: Text('ADD User'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserForm()),
          );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
               Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
               );
            },
          ),
        ],
      ),
    );
  }
}
