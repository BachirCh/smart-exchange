import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_reclam/components/map.dart';
import 'package:smart_reclam/components/reclamation.dart';

import '../utils.dart';

class ConstatDeclaration extends StatelessWidget {
  final Reclamation reclamation;
  final String? placemark;
  ConstatDeclaration({super.key, required this.reclamation, this.placemark});

  late final GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FutureBuilder(
          future: getUserRole(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data == 'agent' &&
                reclamation.statut == 'ouvert') {
              return FloatingActionButton.extended(
                onPressed: () {
                  showTraitementDialog(context);
                },
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(
                  'Traiter',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16,
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
                  else if (reclamation.statut == 'traité')
                    Badge(
                      label: Text('traité'),
                      backgroundColor: Colors.green[800],
                    )
                  else if (reclamation.statut == 'clôturé')
                    Badge(
                      label: Text('clôturé'),
                      backgroundColor: Colors.red[800],
                    ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Type',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                reclamation.type ?? '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 16,
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
                DateFormat('dd/MM/yyyy, HH:mm')
                    .format(reclamation.horaire!.toDate()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              SizedBox(
                height: 16,
              ),
              Text(
                'Adresse',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placemark ?? '-',
                    // widget.reclamation.adresse == null
                    //     ? '-'
                    //     : "${widget.reclamation.adresse!.latitude.toString()}, ${widget.reclamation.adresse!.longitude.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConstatMap(
                                    lat: reclamation.adresse!.latitude,
                                    long: reclamation.adresse!.longitude,
                                  )),
                        );
                      },
                      child: Text('Voir sur la carte'))
                ],
              ),
              SizedBox(
                height: 16,
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
                reclamation.prefecture ?? '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              SizedBox(
                height: 16,
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
                reclamation.remarqueDeclaration ?? '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 16,
              ),
              if (reclamation.imageUrl != null &&
                  reclamation.imageUrl!.isNotEmpty)
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Image(
                    image: NetworkImage(reclamation.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                )
              // else
              //   Image(
              //     image: AssetImage('assets/images/photo1.jpeg'),
              //     fit: BoxFit.cover,
              //     height: 120,
              //     width: 120,
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _imageVTraitement = ValueNotifier<Uint8List?>(null);

  void selectImage(source) async {
    Uint8List img = await pickImage(source);
    _imageVTraitement.value = img;
  }

  showTraitementDialog(context) {
    var remarqueTraitementController = TextEditingController();

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
                          "Traiter le constat",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: remarqueTraitementController,
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
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _imageVTraitement,
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
                                                _imageVTraitement.value = null;
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
                                    _imageVTraitement.value != null) {
                                  var remarqueTraitement =
                                      remarqueTraitementController.text;
                                  // var horaire = horaireController.text;
                                  var horaireTraitement = DateTime.now();

                                  traiterReclamation(
                                    reclamationId: reclamation.id,
                                    imageTraitement: _imageVTraitement.value,
                                    remarqueTraitement: remarqueTraitement,
                                    horaireTraitement:
                                        Timestamp.fromDate(horaireTraitement),
                                  );
                                  Navigator.pop(context);
                                  _imageVTraitement.value = null;
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
