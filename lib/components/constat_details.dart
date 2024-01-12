import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import '../pages/declaration.dart';
import '../pages/traitement.dart';
import '../pages/cloture.dart';
import 'reclamation.dart';

class ConstatPage extends StatefulWidget {
  final String type;
  final String id;
  const ConstatPage({super.key, required this.type, required this.id});

  @override
  State<ConstatPage> createState() => _ConstatPageState();
}

class _ConstatPageState extends State<ConstatPage> {
  Reclamation reclamation = Reclamation(
    id: '',
    code: '',
    statut: '',
    prefecture: '',
    imageUrl: '',
    horaire: Timestamp.now(),
    chrono: null,
    adresse: GeoPoint(33.5731, -7.5898),
    type: '',
    remarqueDeclaration: '',
    remarqueTraitement: '',
    horaireTraitement: Timestamp.now(),
  );

  String placemark = '';

  @override
  void initState() {
    super.initState();
    fetchRecord();
  }

  fetchRecord() async {
    final record = await FirebaseFirestore.instance
        .collection('reclamation')
        .doc(widget.id)
        .get();
    mapRecord(record);
    getPlacemark(reclamation);

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
        imageUrl: data['imageUrl'],
        remarqueDeclaration: data['remarqueDeclaration'],
        remarqueTraitement: data['remarqueTraitement'],
        horaireTraitement: data['horaireTraitement'],
        type: data['type']);
    // var entry = Reclamation.fromJson(data!);

    if (mounted) {
      setState(() {
        reclamation = entry;
      });
    }
  }

  getPlacemark(record) async {
    // var data = record.data();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        record.adresse.latitude, record.adresse.longitude);
    Placemark place = placemarks[0];
    setState(() {
      placemark = '${place.street}, ${place.postalCode}, ${place.locality}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // color: theme
          //     .colorScheme.onPrimaryContainer,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: 
      reclamation.statut == "ouvert" ? DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Déclaration'),
            ],
          ),
          body: TabBarView(
            children: [
              ConstatDeclaration(
                reclamation: reclamation,
                placemark: placemark,
              ),
             
            ],
          ),
        ),
      ) :
      reclamation.statut == "traité" ? DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Déclaration'),
              Tab(text: 'Traitement'),
            ],
          ),
          body: TabBarView(
            children: [
              ConstatDeclaration(
                reclamation: reclamation,
                placemark: placemark,
              ),
              ConstatTraitement(
                reclamation: reclamation,
              ),
            ],
          ),
        ),
      ) :
      DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Déclaration'),
              Tab(text: 'Traitement'),
              Tab(text: 'Clôture'),
            ],
          ),
          body: TabBarView(
            children: [
              ConstatDeclaration(
                reclamation: reclamation,
                placemark: placemark,
              ),
              ConstatTraitement(
                reclamation: reclamation,
              ),
              ConstatCloture(
                reclamation: reclamation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
