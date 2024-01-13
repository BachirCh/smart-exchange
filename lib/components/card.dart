// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_reclam/utils.dart';
import '../pages/reclamation_tabs.dart';

class ConstatCard extends StatefulWidget {
  final String statut;
  final String type;
  final String code;
  final Timestamp horaire;
  final Timestamp? horaireTraitement;
  final Timestamp chrono2;
  final String? prefecture;
  final int? chrono;
  final String id;
  final String? imageUrl;

  ConstatCard(
      {super.key,
      required this.id,
      required this.statut,
      required this.type,
      required this.code,
      required this.horaire,
      required this.chrono2,
      this.prefecture,
      this.horaireTraitement,
      this.chrono,
      this.imageUrl});

      getDiff() {
        int diff =
        chrono2.toDate().difference(horaire.toDate()).inMinutes;
        if (diff <=0 && statut == 'ouvert') {
          expirerReclamation(reclamationId: id);
        }
      }

  setState() {
    int diff =
        horaireTraitement?.toDate().difference(horaire.toDate()).inMinutes ?? 0;
        print("------------ $diff");
  }

  @override
  State<ConstatCard> createState() => _ConstatCardState();
}

class _ConstatCardState extends State<ConstatCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConstatPage(type: widget.type, id: widget.id)),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   color: (Colors.grey[300])!, //<-- SEE HERE
          // ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        surfaceTintColor: Colors.white,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Image(
                    image: NetworkImage(widget.imageUrl!),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 120,
                  ),
                ),
              // else
              //   Image(
              //     image: AssetImage('assets/images/photo1.jpeg'),
              //     fit: BoxFit.cover,
              //     height: 120,
              //     width: 120,
              //   ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            widget.code,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          // MyTimer(),
                          SizedBox(
                            width: 4,
                          ),

                          if (widget.statut == 'ouvert')
                            Badge(
                              label: Text('ouvert'),
                              backgroundColor: Colors.amber[800],
                            )
                          else if (widget.statut == 'traité')
                            Badge(
                              label: Text('traité'),
                              backgroundColor: Colors.green[800],
                            )
                          else if (widget.statut == 'clôturé')
                            Badge(
                              label: Text('clôturé'),
                              backgroundColor: Colors.grey[800],
                            )
                          else if (widget.statut == 'expiré')
                            Badge(
                              label: Text('expiré'),
                              backgroundColor: Colors.red[800],
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.pin_drop,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(widget.prefecture ?? ''),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_month,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                              "Déclaré le \n ${DateFormat('dd/MM/yyyy, HH:mm').format(widget.horaire.toDate())}"),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.timer_outlined,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          if (widget.statut == 'ouvert')
                            Text(
                                'À traiter avant le \n ${DateFormat('dd/MM/yyyy, HH:mm').format(widget.chrono2.toDate())}')
                          else if (widget.chrono == 0 ||
                              widget.statut == 'clôturé')
                            Text(
                                'Traité le \n ${DateFormat('dd/MM/yyyy, HH:mm').format(widget.horaire.toDate())}')
                          else if (widget.statut == 'traité' ||
                              widget.statut == 'clôturé')
                            Text(
                                'Traité le \n ${DateFormat('dd/MM/yyyy, HH:mm').format(widget.horaireTraitement?.toDate() ?? DateTime.now())}'),
                          // else if (statut == 'clôturé') Text('Clôturé le \n $chrono2'),
                          // MyTimer(
                          //   chrono: chrono ?? 60,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
