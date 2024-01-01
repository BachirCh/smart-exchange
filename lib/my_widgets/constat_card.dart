// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './constat_details.dart';
import './timer.dart';

class ConstatCard extends StatelessWidget {
  final String statut;
  final String type;
  final String code;
  final String horaire;
  final String? prefecture;
  final int? chrono;
  final String id;
  
  const ConstatCard({super.key, required this.id, required this.statut, required this.type, required this.code, required this.horaire, this.prefecture, this.chrono});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: (Colors.grey[300])!, //<-- SEE HERE
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          surfaceTintColor: Colors.white,
          clipBehavior: Clip.hardEdge,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/photo1.jpeg'),
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            code,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          // MyTimer(),
                          SizedBox(
                            width: 4,
                          ),

                          if (statut == 'ouvert')
                            Badge(
                              label: Text('Ouvert'),
                              backgroundColor: Colors.amber[800],
                            )
                          else if (statut == 'traité')
                            Badge(
                              label: Text('Traité'),
                              backgroundColor: Colors.green[800],
                            )
                          else if (statut == 'Clôturé')
                            Badge(
                              label: Text('Clôturé'),
                              backgroundColor: Colors.grey[800],
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_month,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(horaire),
                                ],
                              ),
                              SizedBox(
                                height: 4,
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
                                  Text(prefecture ?? ''),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              if (statut == 'ouvert')
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    MyTimer(chrono: chrono ?? 60,),
                                  ],
                                ),
                            ],
                          ),
                          Ink(
                            decoration: ShapeDecoration(
                              // color: theme
                              //     .colorScheme.primaryContainer,
                              shape: CircleBorder(),
                              color: Theme.of(context).highlightColor,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              // color: theme
                              //     .colorScheme.onPrimaryContainer,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           ConstatPage(type: type, id: id)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}
