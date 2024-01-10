
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_reclam/components/dropdown.dart';
import '../components/dropdown2.dart';
import '../utils.dart';
import '../components/constat_list.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _imageV = ValueNotifier<Uint8List?>(null);

  void selectImage(source) async {
    Uint8List img = await pickImage(source);
    _imageV.value = img;
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            tooltip: 'Se déconnecter',
            onPressed: () {
              signOut(context);
            },
          ),
        ],
        title: Image.asset(
          'assets/images/logo.png',
          height: 32,
        ),
      ),
      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (int index) {
      //     setState(() {
      //       currentPageIndex = index;
      //     });
      //   },
      //   indicatorColor: Theme.of(context).colorScheme.primary,
      //   selectedIndex: currentPageIndex,
      //   destinations: const <Widget>[
      //     NavigationDestination(
      //       selectedIcon: Badge(
      //         label: Text('3'),
      //         child: Icon(
      //           Icons.messenger_sharp,
      //           color: Colors.white,
      //         ),
      //       ),
      //       icon: Badge(
      //         label: Text('3'),
      //         child: Icon(Icons.messenger_sharp),
      //       ),
      //       label: 'Constats',
      //     ),
      //     NavigationDestination(
      //       selectedIcon: Badge(
      //         label: Text('8'),
      //         child: Icon(
      //           Icons.notifications,
      //           color: Colors.white,
      //         ),
      //       ),
      //       icon: Badge(
      //         label: Text('8'),
      //         child: Icon(Icons.notifications),
      //       ),
      //       label: 'Réclamations',
      //     ),
      //   ],
      // ),
      body:

          /// Home page
          DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Ouverts'),
              Tab(text: 'Traités'),
              Tab(text: 'Clôturés'),
              Tab(text: 'Expirés'),
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
              ConstatList(
                statut: 'expiré',
                type: 'Constat',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              getLocation();
              showReclamationDialog();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AddReclamation(
              //           addMessage: (message) => print(message))),
              // );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            
            label: const Text('Nouveau constat', style: TextStyle(color: Colors.white),),
            icon: const Icon(Icons.add, color: Colors.white,),
          ),
        ),
      ),

      /// Notifications page
    );
  }

  showReclamationDialog() {
    var codeController = TextEditingController();
    codeController.text =
        "SR-${(DateTime.now().toUtc().millisecondsSinceEpoch ~/ Duration.millisecondsPerMinute).toString()}";
    // var code = DateTime.now().toUtc().millisecondsSinceEpoch;
    // var statutController = TextEditingController();
    var prefectureController = TextEditingController();
    var chronoController = TextEditingController();
    var typeController = TextEditingController();
    var remarqueDeclarationController = TextEditingController();
typeController.text = 'A';
void setType(String value) => setState(() {
          if (value == 'a') {
            typeController.text = 'A';
          } else if (value == 'b') {
            typeController.text = 'B';
          } else if (value == 'c') {
            typeController.text = 'C';
          } else if (value == 'd') {
            typeController.text = 'D';
          } else if (value == 'e') {
            typeController.text = 'E';
          } else if (value == 'f') {
            typeController.text = 'F';
          } else if (value == 'g') {
            typeController.text = 'G';
          }
        });
    void changeChrono(String value) => setState(() {
          if (value == 'a') {
            chronoController.text = '2 heures';
          } else {
            chronoController.text = '24 heures';
          }
        });

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            surfaceTintColor: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Ajouter un constat",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: codeController,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un code du constat';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Code',
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      DropdownMenuExample(
                        list: [
                          "Aïn Chock",
                          "Aïn Sebaâ-Hay Mohammadi",
                          "Anfa",
                          "Ben M'sick",
                          "Bernoussi-Zenata",
                          "Fida-Mers Sultan",
                          "Hay Hassani",
                          "Moulay Rachid"
                        ],
                        controller: prefectureController,
                        label: "Préfecture",
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      DropdownMenuExample2(
                        list: ["a", "b", "c", "d", "e", "f", "g"],
                        setType: setType,
                        changeChrono: changeChrono,
                        label: "Type de constat",
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      TextFormField(
                        controller: chronoController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Chrono',
                        ),
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: remarqueDeclarationController,
                        minLines: 2,
                        maxLines: 3,
                        decoration: InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          alignLabelWithHint: true,
                          labelText: 'remarque',
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      // TextField(
                      //   controller: horaireController,
                      //   keyboardType: TextInputType.datetime,
                      //   decoration: InputDecoration(
                      //     hintText: 'Horaire',
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              selectImage(ImageSource.camera);
                            },
                            label: const Text('Camera'),
                            icon: Icon(Icons.camera),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              selectImage(ImageSource.gallery);
                            },
                            label: const Text('Galerie'),
                            icon: Icon(Icons.image),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _imageV,
                        builder: (context, value, child) {
                          return AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Visibility(
                                  visible: value != null,
                                  key: ValueKey(value),
                                  child: value == null
                                      ? SizedBox()
                                      : Image.memory(value)));
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              // style: ElevatedButton.styleFrom(
                              //   minimumSize: const Size.fromHeight(25),
                              // ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  var statut = "ouvert";
                                  var prefecture = prefectureController.text;
                                  var chrono = 0;
                                  if (chronoController.text == "2 heures") {
                                    chrono = 2 * 3600;
                                  } else {
                                    chrono = 24 * 3600;
                                  }

                                  var code = codeController.text;
                                  var type = typeController.text;
                                  var remarqueDeclaration= remarqueDeclarationController.text;
                                  // var horaire = horaireController.text;
                                  var horaire = DateTime.now();
                                  // print(typeController.text);
                                  addReclamation(
                                     image: _imageV.value,
                                      code :code,
                                      statut: statut,
                                      prefecture : prefecture,
                                     remarqueDeclaration: remarqueDeclaration,
                                      chrono : chrono,
                                     horaire:  Timestamp.fromDate(horaire),
                                      type :type);
                                  Navigator.pop(context);
                                  _imageV.value = null;
                                }
                              },
                              child: Text('Enregistrer')),
                          SizedBox(
                            width: 12,
                          ),
                          TextButton(
                              // style: ElevatedButton.styleFrom(
                              //   minimumSize: const Size.fromHeight(25),
                              // ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Annuler')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
