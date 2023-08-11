import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/screens/bloc/save_event.dart';
import 'package:notes_app/screens/bloc/save_state.dart';

class SaveBloc extends Bloc<SaveEvent,SaveState>{
  SaveBloc():super(SaveInitialState()){
    on<SaveTitleChangeEvent>((event, emit) {
      if(event.titleV==""){
        emit(SaveErrorState("Title should not be empty!"));
      }
      else if(event.descriptionV==""){
        emit(SaveErrorState("Please add description"));
      }else{
        emit(SaveValidState());
      }
    });
    on<SaveSubmiteEvent>((event, emit){
      emit(SaveLoadingState());
    });
  }

}