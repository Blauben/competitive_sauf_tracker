import 'package:flutter/material.dart';
import 'package:sauf_tracker/main_features/drink_selector/body/drink_selector.dart';

import '../../../main.dart';
/*
* This was a Test which failed
* KILL ME Thanks!
* */
class MainScaffold extends StatefulWidget {
  final int initialIndex;
  final String title;
  final Widget body;
  const MainScaffold({Key? key, this.initialIndex = 0, this.title = "Competitive Sauf Tracker", required this.body}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {

  int currentIndex = 0;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  final List<Widget> _pages = <Widget>[
    const DrinkSelectorBody(),
    const Test(),
    const Test()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),
      bottomNavigationBar: BottomNavigationBar(

        items: const [
          BottomNavigationBarItem(
            label: "Drinks",
            icon: Icon(Icons.sports_bar),
          ),
          BottomNavigationBarItem(
              label: "Scoreboard", icon: Icon(Icons.leaderboard)),
          BottomNavigationBarItem(
              label: "Statistics", icon: Icon(Icons.analytics)),
        ],

        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
      ),

    );
  }
}

