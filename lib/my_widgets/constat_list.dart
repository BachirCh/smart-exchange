import 'package:flutter/material.dart';
import './constat_card.dart';

class ConstatList extends StatelessWidget {
  final String status;
  final String title;
  const ConstatList({super.key, required this.status, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text("17 résultats"),
              ),
              SizedBox(
                height: 8,
              ),
              ConstatCard(status: status, title: title),
              ConstatCard(status: status, title: title),

            ],
          ),
        ),
      ),
    );
  }
}
