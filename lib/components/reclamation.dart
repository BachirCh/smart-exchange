import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Reclamation reclamationFromJson(String str) =>
    Reclamation.fromJson(json.decode(str));

String reclamationToJson(Reclamation data) => json.encode(data.toJson());

class Reclamation {
  String? imageUrl;
  String? imageTraitementUrl;
  String id;
  String code;
  String statut;
  String? type;
  String? remarqueDeclaration;
  String? remarqueTraitement;
  Timestamp? horaireTraitement;
  Timestamp? horaire;
  int? chrono;
  Timestamp? chrono2;
  String? prefecture;
  GeoPoint? adresse;

  Reclamation({
    required this.id,
    required this.code,
    required this.statut,
    this.imageUrl,
    this.imageTraitementUrl,
    this.type,
    this.remarqueDeclaration,
    this.remarqueTraitement,
    this.horaire,
    this.horaireTraitement,
    this.chrono,
    this.chrono2,
    this.prefecture,
    this.adresse,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) => Reclamation(
        id: json["id"],
        code: json["code"],
        statut: json["statut"],
        type: json["type"],
        remarqueDeclaration: json["remarqueDeclaration"],
        remarqueTraitement: json["remarqueTraitement"],
        horaireTraitement: json["horaireTraitement"],
        horaire: json["horaire"],
        chrono: json["chrono"],
        chrono2: json["chrono2"],
        prefecture: json["prefecture"],
        adresse: json["adresse"],
        imageUrl: json["imageUrl"],
        imageTraitementUrl: json["imageTraitementUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "type": type,
        "remarqueDeclaration": remarqueDeclaration,
        "remarqueTraitement": remarqueTraitement,
        "horaireTraitement": horaireTraitement,
        "statut": statut,
        "horaire": horaire,
        "chrono": chrono,
        "chrono2": chrono2,
        "prefecture": prefecture,
        "adresse": adresse,
        "imageUrl": imageUrl,
        "imageTraitementUrl": imageTraitementUrl,
      };
}
