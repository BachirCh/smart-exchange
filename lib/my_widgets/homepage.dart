import 'package:flutter/material.dart';
import './constat_list.dart';

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.red,),
            tooltip: 'Se déconnecter',
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 32,
        ),
        
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
  }
}