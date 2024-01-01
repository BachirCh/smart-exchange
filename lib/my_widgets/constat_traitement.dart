import 'package:flutter/material.dart';

class ConstatTraitement extends StatelessWidget {
  final String status;
  const ConstatTraitement({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAlertDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          'Clôturer',
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
                    '1GHCZ-0413223',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  if (status == 'ouvert')
                    Badge(
                      label: Text('ouvert'),
                      backgroundColor: Colors.amber[800],
                    )
                  else if (status == 'Traité')
                    Badge(
                      label: Text('Traité'),
                      backgroundColor: Colors.green[800],
                    )
                  else if (status == 'Clôturé')
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
                'Maintien des déchets verts sur la voie urbaine.',
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
                '21/12/2023, 13:01',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Image(image: AssetImage('assets/images/photo1.jpeg')),
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

showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Annuler"),
    onPressed:  () { 
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Clôturer"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    surfaceTintColor: Colors.white,
    title: Text("Clôturer constat"),
    content: Text("Êtes-vous sûr de vouloir clôturer ce constat ?"),
    actions: [
      cancelButton,
      continueButton,
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