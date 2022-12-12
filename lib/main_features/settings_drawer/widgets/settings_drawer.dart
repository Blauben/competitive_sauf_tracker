import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const <Widget>[
          SizedBox(
            height: 80,
            child: DrawerHeader(
              padding: EdgeInsets.only(top: 20, left: 15),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "Promillerechner konfigurieren",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
