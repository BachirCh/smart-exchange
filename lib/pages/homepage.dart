import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../components/my_file.dart';
import '../components/dropdown.dart';
import '../utils.dart';

String filterQuery = "";
String searchQuery = "";
String sortDateOrder = "desc";

setFilterQuery({search, filter}) {
  final Stream<QuerySnapshot> filesStream = filter == ''
      ? FirebaseFirestore.instance
          .collection('files')
          .where('name', isGreaterThanOrEqualTo: search.toLowerCase())
          .where('name', isLessThanOrEqualTo: "${search.toLowerCase()}\uf8ff")
          .snapshots()
      : FirebaseFirestore.instance
          .collection('files')
          .where('name', isGreaterThanOrEqualTo: search.toLowerCase())
          .where('name', isLessThanOrEqualTo: "${search.toLowerCase()}\uf8ff")
          .where('type', isEqualTo: filter)
          .snapshots();
  return filesStream;
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MyFile> files = [];

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final userEntity = getUserEntity();

  final _fileV = ValueNotifier<PlatformFile?>(null);

  List<String> filters = [
    "Reporting annuel",
    "Reporting mensuel",
    "Plan de collecte",
    "Evolution de tonnage",
  ];

  void selectFile() async {
    PlatformFile? file = await pickFile();
    _fileV.value = file;
  }

  Icon icon = Icon(Icons.arrow_downward);
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    side: MaterialStatePropertyAll(
                        BorderSide(color: Colors.grey.shade400, width: 1.0)),
                    elevation: MaterialStateProperty.all<double>(0),
                    leading: Icon(
                      Icons.search,
                      color: Colors.grey.shade400,
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    // overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
                    // surfaceTintColor:
                    //     MaterialStateProperty.all<Color>(Colors.grey),

                    hintText: "Recherche",
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0)),
                    onTap: () {},
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                      // fetchRecords(query: searchKey);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Filter(
                  onFilterChanged: (String filter) {
                    setState(() {
                      filterQuery = filter;
                    });
                  },
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      // Toggle the sorting order
                      isAscending = !isAscending;

                      // Update the icon based on the sorting order
                      icon = isAscending
                          ? Icon(Icons.arrow_upward)
                          : Icon(Icons.arrow_downward);

                      sortDateOrder = isAscending ? "asc" : "desc";
                    });
                  },
                  icon: icon,
                  label: Text('Date'),
                ),
              ],
            ),
            MyDataTable(
              filterQuery: filterQuery,
              sortDateOrder: sortDateOrder,
            ),
          ],
        ),
      ),
    );
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
                          list: filters,
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
                                        entity: userEntity,
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

class Filter extends StatefulWidget {
  final Function(String) onFilterChanged;

  const Filter({super.key, required this.onFilterChanged});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> filters = [
    "Reporting annuel",
    "Reporting mensuel",
    "Plan de collecte",
    "Evolution de tonnage",
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: filters.map((String val) {
        return ChoiceChip(
          label: Text(val),
          selected: (filterQuery == val),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                filterQuery = val;
              } else {
                filterQuery = '';
              }
            });
            widget.onFilterChanged(filterQuery);
          },
        );
      }).toList(),
    );
  }
}

class MyDataTable extends StatefulWidget {
  final String? filterQuery;
  final String? sortDateOrder;
  const MyDataTable({super.key, this.filterQuery, this.sortDateOrder});

  @override
  State<MyDataTable> createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  List<DocumentSnapshot> listSorted = [];
  @override
  Widget build(BuildContext context) {
    Query filesStream;

    if (widget.filterQuery == null || widget.filterQuery == '') {
      filesStream = FirebaseFirestore.instance
          .collection('files')
          .where('name', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('name',
              isLessThanOrEqualTo: "${searchQuery.toLowerCase()}\uf8ff");
    } else {
      filesStream = FirebaseFirestore.instance
          .collection('files')
          .where('type', isEqualTo: widget.filterQuery)
          .where('name', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('name',
              isLessThanOrEqualTo: "${searchQuery.toLowerCase()}\uf8ff");
    }
    return StreamBuilder<QuerySnapshot>(
        stream: filesStream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          listSorted = snapshot.data!.docs.toList();

          // Sort the list based on the sorting order
          if (widget.sortDateOrder == "desc") {
            listSorted
                .sort((a, b) => b['dateAdded']!.compareTo(a['dateAdded']!));
          } else {
            listSorted
                .sort((a, b) => a['dateAdded']!.compareTo(b['dateAdded']!));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text('${snapshot.data!.docs.length} résultats'),
              SizedBox(height: 20),
              SingleChildScrollView(
                  child: Material(
                      elevation: 2,
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        child: DataTable(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                          ),
                          columns: [
                            DataColumn(label: Text('Nom du document')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Ajouté par')),
                            DataColumn(label: Text('Ajouté le')),
                            DataColumn(label: SizedBox()),
                          ],
                          rows: listSorted.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return DataRow(cells: [
                              DataCell(Text(data['name'])),
                              DataCell(Text(data['type'])),
                              DataCell(Text(data['entity'])),
                              DataCell(Text(DateFormat('dd/MM/yyyy, HH:mm')
                                  .format(data['dateAdded'].toDate()))),
                              DataCell(Row(
                                children: [
                                  TextButton.icon(
                                      onPressed: (() => {
                                            js.context.callMethod(
                                                'open', [data['fileUrl']])
                                          }),
                                      icon: Icon(Icons.download),
                                      label: Text("Télécharger")),
                                  SizedBox(width: 8),
                                  TextButton.icon(
                                      onPressed: (() => {
                                        print(document.id),
                                            confirmDeleteDialog(document.id),
                                          }),
                                      icon: Icon(Icons.close),
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red.shade600),
                                      label: Text(
                                        "Supprimer",
                                      )),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ))),
            ],
          );
        });
  }

  Future<void> confirmDeleteDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer document'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer ce document?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
               deleteFile(id: id);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade600),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
