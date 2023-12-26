import 'package:flutter/material.dart';

class ConstatCloture extends StatelessWidget {
  final String status;
  const ConstatCloture({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 12,
              ),
              Text(
                'Horaire de clôture',
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
            ],
          ),
        ),
      ),
    );
  }
}
