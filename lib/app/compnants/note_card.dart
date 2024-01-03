import 'package:flutter/material.dart';
import 'package:notes_api/app/models/notes_model.dart';
import 'package:notes_api/constant/api_link.dart';
import 'package:notes_api/constant/app_color.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final String img;
  final void Function() myTap;
  final void Function() delete;
  const NoteCard({
    super.key,
    required this.note,
    required this.myTap,
    required this.delete,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: myTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: noteCardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              // Image.asset(
              //   img,
              //   height: 50,
              //   width: 50,
              //   fit: BoxFit.fill,
              // ),
              Image.network(
                "$imageRootLink/${note.noteImage}",
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: ListTile(
                  title: Text(note.noteTitle),
                  subtitle: Text(note.noteContent),
                  trailing: IconButton(
                    onPressed: delete,
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
