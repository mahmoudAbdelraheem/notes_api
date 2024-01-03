import 'package:flutter/material.dart';

import 'package:notes_api/app/compnants/crud.dart';
import 'package:notes_api/app/compnants/note_card.dart';
import 'package:notes_api/app/models/notes_model.dart';
import 'package:notes_api/app/notes/edit_note.dart';

import 'package:notes_api/constant/api_link.dart';
import 'package:notes_api/main.dart';

import '../constant/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Crud _crud = Crud();
  Future<dynamic> getNotes() async {
    var response = await _crud.postRequest(viewNoteLink, {
      "u_id": shardPref.getString("id"),
    });
    print("response body is ====== $response");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text("your notes"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("setting");
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            FutureBuilder(
                future: getNotes(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['status'] == 'falid') {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Add New Note Now!",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (context, index) {
                            return NoteCard(
                              img: "images/note.png",
                              note: NoteModel.fromJson(
                                  snapshot.data['data'][index]),
                              myTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditNote(
                                      note: NoteModel.fromJson(
                                          snapshot.data['data'][index]),
                                    ),
                                  ),
                                );
                              },
                              delete: () async {
                                var response =
                                    await _crud.postRequest(deleteNoteLink, {
                                  "note_id": snapshot.data['data'][index]
                                      ['note_id'],
                                  "image_name": snapshot.data['data'][index]
                                      ['note_image'],
                                });
                                if (response != null &&
                                    response['status'] == 'success') {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'homePage', (route) => false);
                                }
                              },
                            );
                          });
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed("addNote");
        },
        child: const Icon(
          Icons.note_add_outlined,
          color: Colors.black,
        ),
      ),
    );
  }
}
