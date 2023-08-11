
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/internet_event.dart';
import 'package:notes_app/blocs/internet_state.dart';

class InternetBloc extends Bloc<InternetEvent,InternetState>{
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connctivitySubscription;
  InternetBloc():super(InternetInitialState()){
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));
    _connectivity.onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.mobile || result ==ConnectivityResult.wifi){
        add(InternetGainedEvent());
      }else{
        add(InternetLostEvent());
      }
    });

    @override
    Future<void> close(){
      connctivitySubscription?.cancel();
      return super.close();
    }
  }

}