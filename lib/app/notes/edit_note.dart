import 'package:flutter/material.dart';
import 'package:notes_api/constant/api_link.dart';

import '../compnants/crud.dart';
import '../compnants/custom_form_note.dart';
import '../compnants/cutom_button.dart';
import '../compnants/valid_input.dart';

class EditNote extends StatefulWidget {
  final String title;
  final String content;
  final String id;
  const EditNote({
    super.key,
    required this.title,
    required this.content,
    required this.id,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _isLoading = false;
  final Crud _crud = Crud();

  Future<void> editNote() async {
    if (formState.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var response = await _crud.postRequest(updateNoteLink, {
        "new_title": title.text,
        "new_content": content.text,
        "note_id": widget.id,
      });

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
    title.text = widget.title;
    content.text = widget.content;

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
      appBar: AppBar(
        title: const Text("Update Note"),
      ),
      body: Container(
        color: Colors.yellow[200],
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
