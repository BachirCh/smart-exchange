import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_reclam/my_widgets/constat_map.dart';
import 'package:smart_reclam/my_widgets/reclamation.dart';

class ConstatDeclaration extends StatefulWidget {
  final String id;
  const ConstatDeclaration({super.key, required this.id});

  @override
  State<ConstatDeclaration> createState() => _ConstatDeclarationState();
}

class _ConstatDeclarationState extends State<ConstatDeclaration> {
  late GoogleMapController mapController;
  Reclamation reclamation = Reclamation(
      id: '',
      code: '',
      statut: '',
      prefecture: '',
      horaire: Timestamp.now(),
      chrono: null,
      adresse: GeoPoint(0, 0),
      description: '');

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  void initState() {
    super.initState();
    fetchRecord();
  }
//   final ref = FirebaseFirestore.instance.collection('reclamation').doc(widget.id).withConverter(
//       fromFirestore: Reclamation.fromFirestore,
//       toFirestore: (City city, _) => city.toFirestore(),
//     );
// final docSnap = await ref.get();
// final city = docSnap.data();

  fetchRecord() async {
    final record = await FirebaseFirestore.instance
        .collection('reclamation')
        .doc(widget.id)
        .get();
    mapRecord(record);
  }

  mapRecord(DocumentSnapshot<Map<String, dynamic>> record) async {
    var data = record.data();
    var entry = Reclamation(
        id: widget.id,
        code: data!['code'],
        statut: data['statut'],
        prefecture: data['prefecture'],
        horaire: data['horaire'],
        chrono: data['chrono'],
        adresse: data['adresse'],
        description: data['description']);
    if (mounted) {
      setState(() {
        reclamation = entry;
      });
    }
    print(reclamation.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: FormExample(),
                ),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          'Traiter',
          style: TextStyle(color: Colors.white),
        ),
        // icon: Icon(Icons.camera, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                    reclamation.code,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  if (reclamation.statut == 'ouvert')
                    Badge(
                      label: Text('ouvert'),
                      backgroundColor: Colors.amber[800],
                    )
                  else if (reclamation.statut == 'Traité')
                    Badge(
                      label: Text('Traité'),
                      backgroundColor: Colors.green[800],
                    )
                  else if (reclamation.statut == 'Clôturé')
                    Badge(
                      label: Text('Clôturé'),
                      backgroundColor: Colors.grey[800],
                    ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Description',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                reclamation.description ?? "-",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Addresse',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    reclamation.adresse == null
                        ? '-'
                        : "${reclamation.adresse!.latitude.toString()}, ${reclamation.adresse!.longitude.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConstatMap(lat: reclamation.adresse!.latitude, long: reclamation.adresse!.longitude,)),
                        );
                      },
                      child: Text('Voir sur la carte'))
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Préfecture',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Casa Anfa',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Horaire du constat',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                DateFormat('dd/MM/yyyy, hh:mm')
                    .format(reclamation.horaire!.toDate()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Repère',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Remarques',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Image(image: AssetImage('assets/images/photo1.jpeg')),
            ],
          ),
        ),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Traiter constat',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                keyboardType: TextInputType.multiline,
                minLines: 3, //Normal textInputField will be displayed
                maxLines: 5,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  labelText: 'Remarque',
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  alignLabelWithHint: true,
                  hintText: 'Ajouter une remarque',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              _selectedImage != null ? Image.file(_selectedImage!) : SizedBox(),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    label: const Text('Ouvrir galerie'),
                    icon: Icon(Icons.image),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImageFromCamera();
                    },
                    label: const Text('Prendre photo'),
                    icon: Icon(Icons.camera),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'Traiter',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
