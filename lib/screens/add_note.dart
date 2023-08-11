import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/screens/bloc/save_bloc.dart';
import 'package:notes_app/screens/bloc/save_event.dart';
import 'package:notes_app/screens/bloc/save_state.dart';
import 'package:uuid/uuid.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  var uuid=const Uuid().v4();
  final CollectionReference _notes=FirebaseFirestore.instance.collection("Notes");
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();


  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String date=DateTime.now().toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),

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
                    BlocBuilder<SaveBloc,SaveState>(builder: (context,state){
                      if(state is SaveErrorState){
                        return ScaffoldMessenger(child:Text(state.error,style:const TextStyle(color: Colors.red),));
                      }else{
                        return Container();
                      }
                    }),
                    Container(
                      padding:const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white)
                      ),
                      child: TextField(
                        onChanged: (val){
                          BlocProvider.of<SaveBloc>(context).add(SaveTitleChangeEvent(titleController.text,descriptionController.text));
                        },
                        controller: titleController,
                        maxLines: 1,
                        decoration: const InputDecoration(labelText: "Title"),
                      ),
                    ),
                    const SizedBox(height:18),
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
                        Text(date,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                      ],
                    ),
                    const SizedBox(height:18),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                        // width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 1.5)
                        ),
                        child:  TextField(
                          onChanged: (val){
                            BlocProvider.of<SaveBloc>(context).add(SaveTitleChangeEvent(titleController.text, descriptionController.text));
                          },
                          controller: descriptionController,
                          maxLines: 20,
                          enabled: true,
                          cursorHeight: 20,
                          decoration:const InputDecoration(
                            hintText: "Write description...",
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    BlocBuilder<SaveBloc,SaveState>(
                      builder: (context,state) {
                        if(state is SaveValidState) {
                          return ElevatedButton(
                              onPressed: () {

                                BlocProvider.of<SaveBloc>(context).add(SaveSubmiteEvent(titleController.text, descriptionController.text));
                                try {
                                  _notes.add({
                                    'id':uuid.toString(),
                                    'title': titleController.text,
                                    'description': descriptionController.text,
                                    'date':date.toString(),
                                  }).then((value){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Saved!")));
                                    Navigator.pop(context);
                                  }).catchError((e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().trim())));
                                  });
                                }catch(e){

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString())));
                                }

                              }, child: const Text("Save"));
                        }
                        else if(state is SaveLoadingState){

                          return ElevatedButton(
                              onPressed: () {
                              }, child:  SizedBox(height: 30,width:30,child:  const CircularProgressIndicator(strokeWidth: 3,)));
                        }
                        else{
                          return ElevatedButton(
                              onPressed: () {}, child:const Text("Save"));
                        }
                      }
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
