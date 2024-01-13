import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:location/location.dart';
import '../components/reclamation.dart';
import '../components/card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConstatList extends StatefulWidget {
  final String statut;
  final String type;
  const ConstatList({super.key, required this.statut, required this.type});

  @override
  State<ConstatList> createState() => _ConstatListState();
}

class _ConstatListState extends State<ConstatList> {
  List<Reclamation> reclamations = [];

  @override
  void initState() {
    super.initState();
    // LocationService().requestPermission();
    fetchRecords();
    FirebaseFirestore.instance
        .collection("reclamation")
        .where('statut', isEqualTo: widget.statut)
        // .orderBy("horaire", descending: true)
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });

    // FirebaseFirestore.instance
    //     .collection('reclamation')
    //     .where('statut', isEqualTo: widget.statut)
    //     .get()
    //     .then((QuerySnapshot<Map<String, dynamic>> records) {
    //   mapRecords(records);
    // });
  }

  // getLocation() async {
  //   await Geolocator.checkPermission();
  //   await Geolocator.requestPermission();
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  fetchRecords() async {
    final records = await FirebaseFirestore.instance
        .collection('reclamation')
        .where('statut', isEqualTo: widget.statut)
        .get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) async {
    var list = records.docs
        .map((reclamation) => Reclamation(
              id: reclamation.id,
              type: reclamation.data()['type'],
              remarqueDeclaration: reclamation.data()['remarqueDeclaration'],
              code: reclamation.data()['code'],
              statut: reclamation.data()['statut'],
              prefecture: reclamation.data()['prefecture'],
              horaire: reclamation.data()['horaire'],
              chrono: reclamation.data()['chrono'],
              chrono2: reclamation.data()['chrono2'],
              horaireTraitement: reclamation.data()['horaireTraitement'],
              imageUrl: reclamation.data()['imageUrl'],
            ))
        .toList()
      ..sort((a, b) => b.horaire!.compareTo(a.horaire!));
    if (mounted) {
      setState(() {
        reclamations = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),

            if (reclamations.isEmpty)
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    SvgPicture.asset(
                      'assets/images/empty.svg',
                      width: 150,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Aucun résultat',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("${reclamations.length} résultats"),
                  ),
                  SizedBox(
                    height: 800,
                    child: ListView.builder(
                      itemCount: reclamations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: ConstatCard(
                            id: reclamations[index].id,
                            code: reclamations[index].code,
                            horaire: reclamations[index].horaire ?? Timestamp.fromDate(DateTime.now()),
                            chrono2: reclamations[index].chrono2 ?? Timestamp.fromDate(DateTime.now()),
                            horaireTraitement: reclamations[index].horaireTraitement,
                            prefecture: reclamations[index].prefecture,
                            statut: reclamations[index].statut,
                            type: 'Accident',
                            chrono: reclamations[index].chrono,
                            imageUrl: reclamations[index].imageUrl,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            // GetUserName('O4CxCbYmJZG9wUxvtV5w'),
            // MyWidget(),
          ],
        ),
      ),
    );
  }
}

// class LocationService {
//   Location location = Location();

//   Future<bool> requestPermission() async {
//     final permission = await location.requestPermission();
//     return permission == PermissionStatus.granted;
//   }

//   Future<LocationData> getCurrentLocation() async {
//     final serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       final result = await location.requestService;
//       if (result == true) {
//         print('Service has been enabled');
//       } else {
//         throw Exception('GPS service not enabled');
//       }
//     }

//     final locationData = await location.getLocation();
//     print("-------------------");
//     return locationData;
//   }
// }

// class GetUserName extends StatelessWidget {
//   final String documentId;

//   GetUserName(this.documentId);

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users = FirebaseFirestore.instance.collection('reclamation');

//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

//         if (snapshot.hasError) {
//           print(snapshot);
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }

//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//           return Text("Full Name: ${data['code']}");
//         }

//         return Text("loading");
//       },
//     );
//   }
// }

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // inside the <> you enter the type of your stream
//       stream: FirebaseFirestore.instance.collection("reclamation").snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(
//                   // snapshot.data!.docs[index].get('code'),
//                 'test'
//                 ),
//               );
//             },
//           );
//         }
//         if (snapshot.hasError) {
//           return const Text('Error');
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }