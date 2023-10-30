import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../../core/error/failures.dart';

part 'lists_page_event.dart';

part 'lists_page_state.dart';

class ListsPageBloc extends Bloc<ListsPageEvent, ListsPageState> {
  ListsPageBloc()
      : super(const ListsPageState(listsPageStatus: ListsPageStatus.initial)) {
    on<ListsPageEvent>((event, emit) {
      if(event is NavigateToListPageEvent){
        emit(state.copyWith(
            listsPageStatus: ListsPageStatus.navigateList,
            navigateList: event.list));
      }
    });
  }
}
