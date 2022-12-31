import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sauf_tracker/main_features/pending_drinks/body/pending_drinks.dart';
import 'package:sauf_tracker/util_features/cache/repository/cache.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/models/pending_drink.dart';
import 'package:sauf_tracker/util_features/offlineDatabase/domain/repository/db_opt.dart';
import 'package:sauf_tracker/util_features/persistence.dart';

import 'main_features/drink_selector/body/drink_category_selector.dart';
import 'main_features/settings_drawer/widgets/settings_drawer.dart';

void main() async {
  DBOptRepo.resetDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sauf App",
      theme: ThemeData.dark(),
      home: const MainScreen(title: "Competitive Sauf Tracker"),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  int currentIndex = 0;

  final List<Widget> _pages = <Widget>[
    const DrinkCategorySelectorBody(),
    const PendingDrinksBody(),
    const Test(),
    const Test(),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return Scaffold(
    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );

    return Scaffold(
        drawer: const SettingsDrawer(),
        body: _pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              label: "Drinks",
              icon: Icon(Icons.sports_bar),
            ),
            BottomNavigationBarItem(
              label: "Pending",
              icon: _buildStreamBuilderForPendingIcon(),
            ),
            const BottomNavigationBarItem(
                label: "Scoreboard", icon: Icon(Icons.leaderboard)),
            const BottomNavigationBarItem(
                label: "Statistics", icon: Icon(Icons.analytics)),
          ],
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
        ));
  }

  StreamBuilder _buildStreamBuilderForPendingIcon() {
    var s = StreamBuilder<List<PendingDrink>>(
      stream: Cache.pendingDrinksUpdateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Icon(Icons.timelapse_rounded);
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Badge(
            badgeContent: Text(snapshot.data!.length.toString()),
            child: Icon(Icons.timelapse_rounded),
          );
        } else {
          return Icon(Icons.timelapse_rounded);
        }
      },
    );

    PersistenceLayer.fetchPendingDrinks();
    return s;
  }
}

//Test Widget: TODO remove after testing
class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Image.asset("images/Augustiner_Helles.jpg"));
  }
}
