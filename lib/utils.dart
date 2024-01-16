import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/login.dart';

addFile({
  name,
  type,
  dateAdded,
  file,
}) async {
  String fileUrl = '';

  if (file != null) {
    fileUrl = await uploadFile(file);
  }

  FirebaseFirestore.instance.collection('files').add({
    'name': name.toLowerCase(),
    'fileUrl': fileUrl,
    'dateAdded': dateAdded,
    'type': type,
  });
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
  final result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ['pdf', 'doc', 'docx','xls','xlsx','ppt','pptx', ]);

  if (result != null && result.files.isNotEmpty) {
    return result.files.first;
  }
}

Future<String> uploadFile(PlatformFile? file) async {
  final fileBytes = file!.bytes;
  final fileName = file.name;

  // upload file
  await FirebaseStorage.instance.ref('files/$fileName').putData(fileBytes!);

  Reference ref = FirebaseStorage.instance.ref('files/$fileName');

  final url = await ref.getDownloadURL();

  return url;
}

getUserRole() async {
  // final user = FirebaseAuth.instance.currentUser;
  // final role = await FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(user!.uid)
  //     .get();
  // return role.data()!['role'];
}


