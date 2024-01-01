import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './reclamation.dart';
import './constat_card.dart';

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
    print(widget.statut);
    fetchRecords();
    FirebaseFirestore.instance
        .collection('reclamation').where('statut', isEqualTo: widget.statut)
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
              code: reclamation.data()['code'],
              statut: reclamation.data()['statut'],
              prefecture: reclamation.data()['prefecture'],
              horaire: reclamation.data()['horaire'],
              chrono: reclamation.data()['chrono'],
            ))
        .toList();
    // print(DateFormat('dd/MM/yyyy, hh:mm').format(list[0].horaire!.toDate()));
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("${reclamations.length} résultats"),
            ),
            // SizedBox(
            //   height: 8,
            // ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: reclamations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: ConstatCard(
                      id: reclamations[index].id,
                      code: reclamations[index].code,
                      horaire: DateFormat('dd/MM/yyyy, hh:mm')
                          .format(reclamations[index].horaire!.toDate()),
                      prefecture: reclamations[index].prefecture,
                      statut: reclamations[index].statut,
                      type: 'Accident',
                      chrono: reclamations[index].chrono,
                    ),
                  );
                },
              ),
            ),
            // GetUserName('O4CxCbYmJZG9wUxvtV5w'),
            // MyWidget(),
          ],
        ),
      ),
    );
  }
}

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