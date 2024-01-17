import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'pages/login.dart';

addFile({
  name,
  type,
  dateAdded,
  entity,
  file,
}) async {
  String fileUrl = '';
  // List searchOptions = name.toString().toLowerCase().split(' ');

  if (file != null) {
    fileUrl = await uploadFile(file);
  }

  String entity = await getUserEntity();

  FirebaseFirestore.instance.collection('files').add({
    'name': name.toLowerCase(),
    'fileUrl': fileUrl,
    'dateAdded': dateAdded,
    'type': type,
    'entity': entity,
  });
}

deleteFile({id}) async {
  print(id);
  FirebaseFirestore.instance
      .collection('files')
      .doc(id)
      .delete().then((value) => print("file Deleted"));
}

signOut(context) async {
  await FirebaseAuth.instance.signOut();
  // ignore: use_build_context_synchronously
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
  );
}

pickFile() async {
  final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
      ]);

  if (result != null && result.files.isNotEmpty) {
    return result.files.first;
  }
}

Future<String> uploadFile(PlatformFile? file) async {
  final fileBytes = file!.bytes;
  final fileName = file.name;
  await FirebaseStorage.instance.ref('files/$fileName').putData(fileBytes!);
  final fileUrl =
      FirebaseStorage.instance.ref().child('files/$fileName').getDownloadURL();
  return fileUrl;
}

getUserEntity() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final entity =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return entity.data()!['entity'];
}
