import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_api/app/models/notes_model.dart';
import 'package:notes_api/constant/api_link.dart';
import 'package:notes_api/constant/app_color.dart';

import '../compnants/crud.dart';
import '../compnants/custom_form_note.dart';
import '../compnants/cutom_button.dart';
import '../compnants/valid_input.dart';

class EditNote extends StatefulWidget {
  final NoteModel note;
  const EditNote({
    super.key,
    required this.note,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _isLoading = false;
  File? myFile;
  final Crud _crud = Crud();

  Future<void> editNote() async {
    if (formState.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var response;
      if (myFile == null) {
        response = await _crud.postRequest(updateNoteLink, {
          "new_title": title.text,
          "new_content": content.text,
          "note_image": widget.note.noteImage,
          "note_id": widget.note.noteId,
        });
      } else {
        response = await _crud.postRequestWithImage(
            updateNoteLink,
            {
              "new_title": title.text,
              "new_content": content.text,
              "note_image": widget.note.noteImage,
              "note_id": widget.note.noteId,
            },
            myFile!);
      }

      if (response != null && response['status'] == "success") {
        _isLoading = false;
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            "homePage",
            (route) => false,
          );
        }
        print('add success ===========');
      } else {
        print('faild to add note =============');
      }
    }
  }

  @override
  void initState() {
    title.text = widget.note.noteTitle;
    content.text = widget.note.noteContent;

    super.initState();
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
        title: const Text("Update Note"),
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
            icon: const Icon(
              Icons.image_outlined,
              color: Colors.black,
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
                          txt: 'Update Note',
                          color: Colors.yellow,
                          pressed: () async {
                            await editNote();
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
