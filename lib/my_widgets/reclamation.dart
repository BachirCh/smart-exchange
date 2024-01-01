import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Reclamation reclamationFromJson(String str) =>
    Reclamation.fromJson(json.decode(str));

String reclamationToJson(Reclamation data) => json.encode(data.toJson());

class Reclamation {
  String id;
  String code;
  String statut;
  String? description;
  Timestamp? horaire;
  int? chrono;
  String? prefecture;
  GeoPoint? adresse;

  Reclamation({
    required this.id,
    required this.code,
    required this.statut,
    this.description,
    this.horaire,
    this.chrono,
    this.prefecture,
    this.adresse,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) => Reclamation(
        id: json["id"],
        code: json["code"],
        statut: json["statut"],
        description: json["description"],
        horaire: json["horaire"],
        chrono: json["chrono"],
        prefecture: json["prefecture"],
        adresse: json["adresse"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "statut": statut,
        "horaire": horaire,
        "chrono": chrono,
        "prefecture": prefecture,
        "adresse": adresse,
      };
}
