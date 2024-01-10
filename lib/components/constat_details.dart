import 'package:flutter/material.dart';
import './constat_declaration.dart';
import './constat_traitement.dart';
import '../pages/constat_cloture.dart';

class ConstatPage extends StatelessWidget {
  final String type;
  final String id;
  const ConstatPage({super.key, required this.type, required this.id });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
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
                id: id,
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
