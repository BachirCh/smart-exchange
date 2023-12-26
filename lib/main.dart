import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './my_widgets/constat_list.dart';

import './my_widgets/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'smart_reclam',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.menu),
          title: Image.asset(
            'assets/images/logo.png',
            height: 32,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Theme.of(context).colorScheme.primary,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Badge(
                label: Text('3'),
                child: Icon(
                  Icons.messenger_sharp,
                  color: Colors.white,
                ),
              ),
              icon: Badge(
                label: Text('3'),
                child: Icon(Icons.messenger_sharp),
              ),
              label: 'Constats',
            ),
            NavigationDestination(
              selectedIcon: Badge(
                label: Text('8'),
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              icon: Badge(
                label: Text('8'),
                child: Icon(Icons.notifications),
              ),
              label: 'Réclamations',
            ),
          ],
        ),
        body: <Widget>[
          /// Home page
          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TabBar(
                tabs: [
                  Tab(text: 'Ouverts'),
                  Tab(text: 'Traités'),
                  Tab(text: 'Clôturés'),
                ],
              ),
              body: TabBarView(
                children: [
                  ConstatList(
                    status: 'Ouvert',
                    title: 'Constat',
                  ),
                  ConstatList(
                    status: 'Traité',
                    title: 'Constat',
                  ),
                  ConstatList(
                    status: 'Clôturé',
                    title: 'Constat',
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const NewClaimPage()),
                  // );
                },
                label: const Text('Nouveau constat'),
                icon: const Icon(Icons.add),
              ),
            ),
          ),

          /// Notifications page

          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TabBar(
                tabs: [
                  Tab(text: 'Ouverts'),
                  Tab(text: 'Traités'),
                  Tab(text: 'Clôturés'),
                ],
              ),
              body: TabBarView(
                children: [
                  ConstatList(
                    status: 'Ouvert',
                    title: 'Réclamation',
                  ),
                  ConstatList(
                    status: 'Traité',
                    title: 'Réclamation',
                  ),
                  ConstatList(status: 'Clôturé', title: 'Réclamation'),
                ],
              ),
            ),
          )

          /// Messages page
        ][currentPageIndex],
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var texts = appState.favorites;
    print(texts[0]);
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('You have ${texts.length} favorites')),
        for (var text in texts)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(text.asLowerCase),
          )
      ],
    );
  }
}
