import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../components/reclamation.dart';

class ConstatCloture extends StatelessWidget {
  final Reclamation reclamation;
  const ConstatCloture({super.key, required this.reclamation});

  @override
  Widget build(BuildContext context) {
    return reclamation.statut == 'ouvert'
        ? Scaffold(
            body: Center(
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
                  "Ce constat n'est pas encore traité",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ))
        : reclamation.statut == 'traité'
            ? Scaffold(
                body: Center(
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
                      "Ce constat n'a pas encore été clôturé",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ))
            : reclamation.statut == 'expiré'
                ? Scaffold(
                    body: Center(
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
                          "Ce constat a expiré sans traitement ni clôture.",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ))
                : Scaffold(
                    body: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
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
                                    backgroundColor: Colors.grey[800],
                                  )
                                else if (reclamation.statut == 'expiré')
                                  Badge(
                                    label: Text('expiré'),
                                    backgroundColor: Colors.red[800],
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
                              DateFormat('dd/MM/yyyy, HH:mm').format(
                                  reclamation.horaire?.toDate() ??
                                      DateTime.now()),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}
