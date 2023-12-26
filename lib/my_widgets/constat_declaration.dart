import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConstatDeclaration extends StatelessWidget {
  final String status;
  const ConstatDeclaration({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: FormExample(),
                ),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          'Traiter',
          style: TextStyle(color: Colors.white),
        ),
        // icon: Icon(Icons.camera, color: Colors.white,),
      ),
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
                'Description',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Maintien des déchets verts sur la voie urbaine.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Addresse',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '2, rue Hassan 2, Maarif, Casablanca',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Préfecture',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Casa Anfa',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Horaire du constat',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '20/12/2023, 17:53',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Repère',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Remarques',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 12,
              ),
              Image(image: AssetImage('assets/images/photo1.jpeg')),
              SizedBox(
                height: 12,
              ),
              Image(image: AssetImage('assets/images/photo1.jpeg')),
            ],
          ),
        ),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Traiter constat',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                keyboardType: TextInputType.multiline,
                minLines: 3, //Normal textInputField will be displayed
                maxLines: 5,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  labelText: 'Remarque',
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  alignLabelWithHint: true,
                  hintText: 'Ajouter une remarque',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              _selectedImage != null ? Image.file(_selectedImage!) : SizedBox(),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    label: const Text('Ouvrir galerie'),
                    icon: Icon(Icons.image),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickImageFromCamera();
                    },
                    label: const Text('Prendre photo'),
                    icon: Icon(Icons.camera),
                  ),
                ],
              ),
              SizedBox(
                    height: 8,
                  ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'Traiter',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
