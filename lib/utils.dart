 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'pages/login.dart';

 addReclamation({image, code, statut, type, prefecture, chrono,
       horaire, remarqueDeclaration}) async {
        
        String imgIUrl = '';

        if( image != null){
         imgIUrl = await uploadImage(image);
        }

    FirebaseFirestore.instance.collection('reclamation').add({
      'imageUrl':imgIUrl,
      'code': code,
      'statut': statut,
      'prefecture': prefecture,
      'chrono': chrono,
      'horaire': horaire,
      'remarqueDeclaration': remarqueDeclaration,
      'type': type,
      'adresse': GeoPoint(
          (await getLocation()).latitude, (await getLocation()).longitude),
    });
  }

getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  signOut(context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

pickImage(ImageSource source) async{
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: source);
  if(image != null){
    return await image.readAsBytes();
  }
print ('no image selected');
}

Future<String> uploadImage(Uint8List image)async{
  FirebaseStorage storage = FirebaseStorage.instance;

  Reference ref = storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

  final uploadTask = ref.putData(image);

    await uploadTask.snapshotEvents.firstWhere((element) => element.state == TaskState.success);

  final url = await ref.getDownloadURL();

  return  url;

}