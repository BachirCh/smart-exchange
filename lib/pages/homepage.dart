import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final userRole = getUserRole();

  final _imageV = ValueNotifier<Uint8List?>(null);

  void selectImage(source) async {
    Uint8List img = await pickImage(source);
    _imageV.value = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 50,
        leading: Column(
          children: [
            SvgPicture.asset(
              'assets/images/face.svg',
              width: 24,
            ),
            FutureBuilder(
                future: getUserRole(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data == "agent" ? "Agent" : "Admin", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),);
                  } else {
                    return SizedBox();
                  }
                }),
          ],
        ),
        // leading: Text(userRole == "agent" ? "Agent" : "Admin"),
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

      body: DefaultTabController(
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
          floatingActionButton: FutureBuilder(
              future: getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == 'admin') {
                  return FloatingActionButton.extended(
                    onPressed: () {
                      getLocation();
                      showReclamationDialog();
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: const Text(
                      'Nouveau constat',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ),
      ),

      /// Notifications page
    );
  }

  showReclamationDialog() {
    var codeController = TextEditingController();
    codeController.text =
        "SR-${(DateTime.now().toUtc().millisecondsSinceEpoch ~/ Duration.millisecondsPerMinute).toString()}";

    var prefectureController = TextEditingController();
    var chronoController = TextEditingController();
    var typeController = TextEditingController();
    var remarqueDeclarationController = TextEditingController();
    typeController.text = 'Secteur non balayé ou collecté';
    chronoController.text = '24 heures';
    void changeChrono(String value) => setState(() {
          if (value == 'Secteur non balayé ou collecté' ||
              value == 'Points noirs non éradiqués' ||
              value == 'Artères ou place non lavées' ||
              value == 'Poubelle ou conteneur détérioré' ||
              value == 'Véhicule pollué' ||
              value == 'Terrains vagues avec déchets') {
            chronoController.text = '24 heures';
          } else if (value == 'Déchets laissés sur place' ||
              value == 'Boulevard/rue/place non balayés' ||
              value == 'Véhicule répandant des ordures') {
            chronoController.text = '2 heures';
          } else {
            chronoController.text = 'Immediat';
          }
        });
    void setType(String value) => setState(() {
          typeController.text = value;
          changeChrono(value);
        });

    showDialog(
        barrierDismissible: false,
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
                        list: [
                          "Secteur non balayé ou collecté",
                          "Déchets laissés sur place",
                          "Boulevard/rue/place non balayés",
                          "Points noirs non éradiqués",
                          "Déchêts non évacués",
                          "Artères ou place non lavées",
                          "Poubelle ou conteneur détérioré",
                          "Véhicule pollué",
                          "Véhicule répandant des ordures",
                          "Véhicule laissant échapper lixiviat",
                          "Véhicule présenté en mauvais état",
                          "Terrains vagues avec déchets",
                          "Non-respect du lieu de vidage",
                        ],
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
                          // OutlinedButton.icon(
                          //   onPressed: () {
                          //     selectImage(ImageSource.gallery);
                          //   },
                          //   label: const Text('Galerie'),
                          //   icon: Icon(Icons.image),
                          // ),
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
                                      : Stack(children: [
                                          Image.memory(value),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton.filled(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                _imageV.value = null;
                                              },
                                              color: Colors.white,
                                            ),
                                          ),
                                        ])));
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
                                if (_formKey.currentState!.validate() &&
                                    _imageV.value != null) {
                                  var prefecture = prefectureController.text;
                                  var chrono = 0;
                                  // var statut = "ouvert";
                                  if (chronoController.text == "2 heures") {
                                    chrono = 2 * 3600;
                                  } else if (chronoController.text ==
                                      "24 heures") {
                                    chrono = 24 * 3600;
                                  } else {
                                    chrono = 0;
                                  }

                                  var statut =
                                      chrono == 0 ? "clôturé" : "ouvert";
                                  var code = codeController.text;
                                  var type = typeController.text;
                                  var remarqueDeclaration =
                                      remarqueDeclarationController.text;
                                  // var horaire = horaireController.text;
                                  var horaire = DateTime.now();
                                  var chrono2 =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          horaire.millisecondsSinceEpoch +
                                              chrono * 1000);
                                  // print(typeController.text);
                                  // print("-------");
                                  // print(DateTime.fromMillisecondsSinceEpoch(horaire.millisecondsSinceEpoch));
                                  // print(DateTime.fromMillisecondsSinceEpoch(chrono2));
                                  addReclamation(
                                      image: _imageV.value,
                                      code: code,
                                      statut: statut,
                                      prefecture: prefecture,
                                      remarqueDeclaration: remarqueDeclaration,
                                      chrono: chrono,
                                      chrono2: chrono2,
                                      horaire: Timestamp.fromDate(horaire),
                                      type: type);
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
