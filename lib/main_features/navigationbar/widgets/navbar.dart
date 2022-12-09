import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items:  const [
        BottomNavigationBarItem(
          label: "Drinks",
          icon: Icon(Icons.sports_bar),
        ),
        BottomNavigationBarItem(
            label: "Scoreboard",
            icon: Icon(Icons.leaderboard)
        ),
        BottomNavigationBarItem(
            label: "Statistics",
            icon: Icon(Icons.analytics)
        ),


      ],
    );
  }
}

