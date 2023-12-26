import 'package:flutter/material.dart';
import './constat_declaration.dart';
import './constat_traitement.dart';
import './constat_cloture.dart';

class ConstatPage extends StatelessWidget {
  final String title;
  const ConstatPage({super.key, required this.title });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // color: theme
          //     .colorScheme.onPrimaryContainer,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: DefaultTabController(
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
                status: 'Ouvert',
              ),
              ConstatTraitement(
                status: 'Traité',
              ),
              ConstatCloture(
                status: 'Clôturé',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
