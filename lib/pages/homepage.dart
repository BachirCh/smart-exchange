import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../components/my_file.dart';
import '../components/dropdown.dart';
import '../utils.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MyFile> files = [];

  fetchRecords({String? query}) async {
    FirebaseFirestore.instance
        .collection('files')
        .where('name', isGreaterThanOrEqualTo: query ?? '')
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    var list = records.docs
        .map((file) => MyFile(
              id: file.id,
              type: file.data()['type'],
              name: file.data()['name'],
              fileUrl: file.data()['fileUrl'],
              dateAdded: file.data()['dateAdded'].toDate(),
            ))
        .toList();
    if (mounted) {
      setState(() {
        files = list;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // LocationService().requestPermission();
    fetchRecords();
    // FirebaseFirestore.instance
    //     .collection("files")
    //     // .orderBy("horaire", descending: true)
    //     .snapshots()
    //     .listen((records) {
    //   mapRecords(records);
    // });
  }

  final _formKey = GlobalKey<FormState>();
  final userRole = getUserRole();

  final _fileV = ValueNotifier<PlatformFile?>(null);

  void selectFile() async {
    PlatformFile? file = await pickFile();
    _fileV.value = file;
  }

  @override
  Widget build(BuildContext context) {
    String searchKey = "";

    return Scaffold(
      // floatingActionButton: ElevatedButton(onPressed: (){}, child: Text("Ajouter document"), ),
      appBar: AppBar(
        centerTitle: true,

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
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/favicon.svg',
              height: 32,
            ),
            SizedBox(width: 12),
            Text('Smart Exchange',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 400,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                  child: SearchBar(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),),
                    side: MaterialStatePropertyAll(BorderSide(color: Colors.grey.shade400, width: 1.0)),
                    elevation: MaterialStateProperty.all<double>(0),
                    leading: Icon(Icons.search, color: Colors.grey.shade400,),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    // overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
                    // surfaceTintColor:
                    //     MaterialStateProperty.all<Color>(Colors.grey),
                        
                    hintText: "Recherche",
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {},
                    onChanged: (query) {
                      setState(() {
                        searchKey = query;
                      });
                      fetchRecords(query: searchKey);
                    },
                  ),
                ),
                
                ElevatedButton(
                    onPressed: () {
                      addFileDialog();
                    },
                    child: Text('Ajouter un document'))
              ],
            ),
            SizedBox(height: 20),
            // TextField(onChanged: (value) {
            //   setState(() {
            //     searchKey = value;
            //   });
            //   fetchRecords(query: searchKey);
            // }),
            // SizedBox(height: 20),

            SizedBox(height: 20),
            Text('${files.length} résultats'),
            SizedBox(height: 20),
            Material(
                elevation: 2,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: _buildBody(context, searchKey)),
          ],
        ),
      ),

      /// Notifications page
    );
  }

  Widget _buildBody(BuildContext context, searchKey) {
    Stream streamQuery = FirebaseFirestore.instance
        .collection('files')
        .where('name', isGreaterThanOrEqualTo: searchKey)
        .snapshots();
    return StreamBuilder(
        // stream: FirebaseFirestore.instance.collection('files').snapshots(),
        stream: streamQuery,
        builder: (context, snapshot) {
          return DataTable(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
              ),
              columns: [
                DataColumn(label: Text('Nom du document')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Ajouté le')),
                DataColumn(label: SizedBox()),
              ],
              rows: _buildList(context, files)
              //  _buildList(context, snapshot.data.documents)
              );
        });
  }

  List<DataRow> _buildList(BuildContext context, List<MyFile> files) {
    return files.map((file) => _buildListItem(context, file)).toList();
  }

  DataRow _buildListItem(BuildContext context, MyFile file) {
    return DataRow(cells: [
      DataCell(Text(file.name ?? '-')),
      DataCell(Text(file.type)),
      DataCell(Text(DateFormat('dd/MM/yyyy, HH:mm').format(file.dateAdded!))),
      DataCell(TextButton.icon(
          onPressed: (() => {
                js.context.callMethod('open', [file.fileUrl])
              }),
          icon: Icon(Icons.download),
          label: Text("Télécharger"))),
    ]);
  }

  addFileDialog() {
    var typeController = TextEditingController();
    typeController.text = 'Reporting annuel';

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            surfaceTintColor: Colors.white,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ajouter un document",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        DropdownMenuExample(
                          list: [
                            "Reporting annuel",
                            "Reporting mensuel",
                            "Plan de collecte",
                            "Evolution de tonnage",
                          ],
                          controller: typeController,
                          label: "Type du document",
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            selectFile();
                          },
                          label: const Text('Importer fichier'),
                          icon: Icon(Icons.upload),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ValueListenableBuilder(
                          valueListenable: _fileV,
                          builder: (context, value, child) {
                            return AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: Visibility(
                                    visible: value != null,
                                    key: ValueKey(value),
                                    child: value == null
                                        ? SizedBox()
                                        : Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(value.name),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        _fileV.value = null;
                                                      },
                                                      icon: Icon(Icons.close))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          )));
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      _fileV.value != null) {
                                    var type = typeController.text;
                                    var dateAdded = DateTime.now();
                                    addFile(
                                        dateAdded:
                                            Timestamp.fromDate(dateAdded),
                                        type: type,
                                        name: _fileV.value!.name,
                                        file: _fileV.value!);
                                    Navigator.pop(context);
                                    _fileV.value = null;
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
                  ],
                ),
              ),
            ),
          );
        });
  }
}
