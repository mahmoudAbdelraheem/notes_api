import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_api/app/compnants/crud.dart';
import 'package:notes_api/app/compnants/custom_form_note.dart';

import 'package:notes_api/app/compnants/cutom_button.dart';
import 'package:notes_api/app/compnants/show_snack_bar.dart';
import 'package:notes_api/app/compnants/valid_input.dart';
import 'package:notes_api/constant/api_link.dart';
import 'package:notes_api/main.dart';

import '../../constant/app_color.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isImageSelected = false;
  //bool _withImage = false;
  final Crud _crud = Crud();
  File? myFile;

  Future<void> addNote() async {
    if (myFile == null) {
      print("image is note selected successfuly....");
      showSnackBar(context, "you need to select an image for note");
      return;
    }
    if (formState.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var response = await _crud.postRequestWithImage(
          addNoteLink,
          {
            "title": title.text,
            "content": content.text,
            "user_id": shardPref.getString("id"),
          },
          myFile!);

      if (response['status'] == "success") {
        _isLoading = false;
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            "homePage",
            (route) => false,
          );
          print('add success ===========');
        }
      } else {
        print('faild to add note =============');
      }
    }
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text("Add Note"),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 120,
                      color: appBackgroundColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Choose Image From :",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () async {
                                  XFile? cameraFile = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _isImageSelected = true;
                                  });
                                  myFile = File(cameraFile!.path);
                                },
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  XFile? gallaryFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _isImageSelected = true;
                                  });
                                  myFile = File(gallaryFile!.path);
                                },
                                icon: const Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.image_outlined,
              color: _isImageSelected ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formState,
          child: ListView(
            children: [
              Column(
                children: [
                  CustomFormNote(
                    minLine: 1,
                    maxLine: 5,
                    hint: 'Note title',
                    controller: title,
                    keyType: TextInputType.text,
                    isPassword: false,
                    valid: (val) {
                      return validInput(val!, 1, 100);
                    },
                  ),
                  CustomFormNote(
                    minLine: 10,
                    maxLine: 50,
                    hint: 'Note Content',
                    controller: content,
                    keyType: TextInputType.text,
                    isPassword: false,
                    valid: (val) {
                      return validInput(val!, 1, 255);
                    },
                  ),
                  const SizedBox(height: 5),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.orange,
                        ))
                      : CustomBotton(
                          txt: 'Add Note',
                          color: Colors.yellow,
                          pressed: () async {
                            await addNote();
                          },
                          txtColor: Colors.black,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
