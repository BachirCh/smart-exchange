import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import './add_reclamation.dart';
import './login.dart';
import './constat_list.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  int currentPageIndex = 0;
  signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.power_settings_new,
            color: Colors.red,
          ),
          tooltip: 'Se déconnecter',
          onPressed: () {
            signOut();
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
                  statut: 'ouvert',
                  type: 'Constat',
                ),
                ConstatList(
                  statut: 'traité',
                  type: 'Constat',
                ),
                ConstatList(
                  statut: 'clôturé',
                  type: 'Constat',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                showReclamationDialog();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => AddReclamation(
                //           addMessage: (message) => print(message))),
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
                  statut: 'Ouvert',
                  type: 'Réclamation',
                ),
                ConstatList(
                  statut: 'Traité',
                  type: 'Réclamation',
                ),
                ConstatList(statut: 'Clôturé', type: 'Réclamation'),
              ],
            ),
          ),
        )

        /// Messages page
      ][currentPageIndex],
    );
  }

  showReclamationDialog() {
    var codeController = TextEditingController();
    // var statutController = TextEditingController();
    var prefectureController = TextEditingController();
    var chronoController = TextEditingController();
    var horaireController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Ajouter un constat", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: 'Code',
                    ),
                  ),
                  // TextField(
                  //   controller: statutController,
                  //   decoration: InputDecoration(
                  //     hintText: 'Statut',
                  //   ),
                  // ),
                  TextField(
                    controller: prefectureController,
                    decoration: InputDecoration(
                      hintText: 'Préfecture',
                    ),
                  ),
                  TextField(
                    controller: chronoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Chrono',
                    ),
                  ),
                  TextField(
                    controller: horaireController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'Horaire',
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        var code = codeController.text;
                        var statut = "ouvert";
                        var prefecture = prefectureController.text;
                        var chrono = chronoController.text;
                        // var horaire = horaireController.text;
                        var horaire = DateTime.now();
                        addReclamation(code,statut,prefecture,int.parse(chrono),Timestamp.fromDate(horaire));
                        Navigator.pop(context);
                      },
                      child: Text('Enregistrer'))
                ],
              ),
            ),
          );
        });
  }
  addReclamation(String code, String statut, String prefecture, int chrono, Timestamp horaire) {
     FirebaseFirestore.instance.collection('reclamation').add({
      'code': code,
      'statut': statut,
      'prefecture': prefecture,
      'chrono': chrono,
      'horaire': horaire,
  });
}
}