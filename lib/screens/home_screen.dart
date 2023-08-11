import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/internet_bloc.dart';
import 'package:notes_app/blocs/internet_state.dart';
import 'package:notes_app/screens/add_note.dart';
import 'package:notes_app/screens/bloc/save_bloc.dart';

import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Notes');
  List<Color>colors=[
    Colors.white,
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.redAccent,
    Colors.amberAccent,
  ];
  Color color(){
    int i =Random().nextInt(colors.length-1);
    return colors[i];
  }
  List notes = [];
  Future<List> getData() async {
    try {
      List newNotes = []; // Create a new list for the fetched data
      await ref.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          newNotes.add(result.data());
        }
      });
      return newNotes; // Return the new list containing fetched data
    } catch (e) {
      return []; // Return an empty list in case of an error
    }
  }

  Widget buildList(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var dataList = snapshot.data;

            if(dataList!.isEmpty){
              return const Center(child: Text("No notes yet"));
            }
            return GridView.builder(
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 13/10),
              padding: const EdgeInsets.all(8),
              itemCount: dataList?.length,
              itemBuilder: (BuildContext context, int index) {

                return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen(content: dataList,index: index,)));
                    },
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Card(
                        // surfaceTintColor: color(),
                        color: color().withOpacity(0.5),

                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dataList![index]['title'],style: TextStyle(fontSize: 20),),
                              SizedBox(height: 5,),
                               Text(dataList[index]['date'].toString(),style: TextStyle(fontSize: 10),),
                              Text(dataList[index]['description'],style:const TextStyle(fontSize: 15,),overflow: TextOverflow.ellipsis,maxLines: 2,),



                            ],
                          ),
                        ),
                      ),
                    )

                );
              }, );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildItems(dataList) => ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            dataList[index]["title"].toString(),
          ),
          subtitle: Text(dataList[index]["description"].toString()),
        );
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // backgroundColor:const Color(0xFF000633).withOpacity(0.1),
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SaveBloc(),
                    child: AddNewNote(),
                  )));
          setState(() {

          });
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            BlocConsumer<InternetBloc, InternetState>(
                listener: (context, state) {
                  if (state is InternetGainedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Internet connected!!")));
                  } else if (state is InternetLostState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Internet not connected!!")));
                  }
                }, builder: (context, state) {
              if (state is InternetLostState) {
                return const Text("Internet Lost ");
              } else if (state is InternetGainedState) {
                return buildList();
              } else {
                return const Center(child: Text("Loading..."));
              }
            }),
          ],
        ),
      ),
    );
  }
}
