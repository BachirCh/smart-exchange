import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_reclam/utils.dart';

import '../components/reclamation.dart';

class ConstatTraitement extends StatelessWidget {
  final Reclamation reclamation;
  
   ConstatTraitement({super.key, required this.reclamation});

    // Reclamation reclamation = Reclamation(
    final  String placemark = '';

  // fetchRecord() async {
  @override
  Widget build(BuildContext context) {
    return
    reclamation.chrono == 0 && reclamation.statut == "clôturé" ?
    Scaffold(
      body:   Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    SvgPicture.asset(
                      'assets/images/illus2.svg',
                      width: 150,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Ce constat a été clôturé sans traitement.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ))
      :
     Scaffold(
      floatingActionButton: 

      FutureBuilder(
          future: getUserRole(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data == 'admin' &&
                reclamation.statut == 'traité') {
              return FloatingActionButton.extended(
                onPressed: () {
                  showAlertDialog(context);
                },
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(
                  'Clôturer',
                  style: TextStyle(color: Colors.white),
                ),
               
              );
            } else {
              return SizedBox();
            }
          }),
     
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  else if (reclamation.statut== 'traité')
                    Badge(
                      label: Text('traité'),
                      backgroundColor: Colors.green[800],
                    )
                  else if (reclamation.statut== 'clôturé')
                    Badge(
                      label: Text('clôturé'),
                      backgroundColor: Colors.grey[800],
                    ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Remarque',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                reclamation.remarqueTraitement ?? '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Horaire de traitement',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
               DateFormat('dd/MM/yyyy, HH:mm')
                    .format(reclamation.horaireTraitement?.toDate() ?? DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
               if (reclamation.imageUrl != null && reclamation.imageUrl!.isNotEmpty)
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Image(
                  image: NetworkImage(reclamation.imageTraitementUrl!),
                  fit: BoxFit.cover,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Annuler"),
    onPressed:  () { 
      Navigator.pop(context);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("Clôturer"),
    onPressed:  () {
      var horaireCloture = DateTime.now();
      cloturerReclamation(reclamationId: reclamation.id, horaireCloture: horaireCloture);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    surfaceTintColor: Colors.white,
    actionsAlignment: MainAxisAlignment.start,
    title: Text("Clôturer constat"),
    content: Text("Êtes-vous sûr de vouloir clôturer ce constat ?"),
    actions: [
      continueButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}
