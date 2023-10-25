import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lists_page_event.dart';
part 'lists_page_state.dart';

class ListsPageBloc extends Bloc<ListsPageEvent, ListsPageState> {
  ListsPageBloc() : super(ListsPageInitial()) {
    on<ListsPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
