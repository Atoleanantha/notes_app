import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/save_bloc.dart';
import 'bloc/save_event.dart';
import 'bloc/save_state.dart';

class EditScreen extends StatefulWidget {
  EditScreen({super.key, required this.content, required this.index});
  var content;
  int index;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  final CollectionReference _notes =
      FirebaseFirestore.instance.collection("Notes");
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController = TextEditingController(
        text: widget.content[widget.index]['title'].toString());
    descriptionController = TextEditingController(
        text: widget.content[widget.index]['description'].toString());
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 600,
              // width: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: TextField(
                        onChanged: (val) {
                          BlocProvider.of<SaveBloc>(context).add(
                              SaveTitleChangeEvent(titleController.text,
                                  descriptionController.text));
                        },
                        controller: titleController,
                        maxLines: 1,
                        decoration: const InputDecoration(labelText: "Title"),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children:const [
                            Icon(Icons.edit_note_outlined,size: 15,),
                            SizedBox(width: 10,),
                            Text("Description",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                          ],
                        ),
                        Text(widget.content[widget.index]['date'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        // width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: TextField(
                          onChanged: (val) {
                            BlocProvider.of<SaveBloc>(context).add(
                                SaveTitleChangeEvent(titleController.text,
                                    descriptionController.text));
                          },
                          controller: descriptionController,
                          maxLines: 20,
                          enabled: true,
                          cursorHeight: 20,
                          decoration: const InputDecoration(
                              hintText: "Write description...",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          try {
                            _notes.doc(widget.content[widget.index].reference.id).update(
                                {
                                  'title': titleController.text,
                                  'description': descriptionController.text,
                                }
                            ).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Changes Saved!"))
                              );
                              Navigator.pop(context);
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Not saved due to ${e.toString().trim()}"))
                              );
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()))
                            );
                          }
                        },
                      child: const Text("Save"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
