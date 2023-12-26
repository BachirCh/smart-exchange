import 'package:flutter/material.dart';
import './constat_details.dart';
import './timer.dart';

class ConstatCard extends StatelessWidget {
  final String status;
  final String title;
  const ConstatCard({super.key, required this.status, required this.title});

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
                            '1GHCZ-0413223',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          // MyTimer(),
                          SizedBox(
                            width: 4,
                          ),

                          if (status == 'Ouvert')
                            Badge(
                              label: Text('Ouvert'),
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
                                  Text('12/12/2021 12:34'),
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
                                  Text('Casa Anfa'),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              if (status == 'Ouvert')
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    MyTimer(),
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
                                           ConstatPage(title: title)),
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
        SizedBox(
          height: 4,
        ),
      ],
    );
  }
}
