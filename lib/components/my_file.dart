import 'dart:convert';


MyFile fileFromJson(String str) =>
    MyFile.fromJson(json.decode(str));

String fileToJson(MyFile data) => json.encode(data.toJson());

class MyFile {
  String? fileUrl;
  String? entity;
  String type;
  String? name;
  String id;
  DateTime? dateAdded;

  MyFile({
    required this.id,
     this.fileUrl,
     this.entity,
    required this.type,
    this.name,
     this.dateAdded,
   
  });

  factory MyFile.fromJson(Map<String, dynamic> json) => MyFile(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        fileUrl: json["fileUrl"],
        entity: json["entity"],
        dateAdded: json["dateAdded"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "entity": entity,
        "fileUrl": fileUrl,
        "dateAdded": dateAdded,
      };
}
