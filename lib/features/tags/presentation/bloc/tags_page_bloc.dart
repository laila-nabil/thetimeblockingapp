import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_tag_use_case.dart';

part 'tags_page_event.dart';

part 'tags_page_state.dart';

class TagsPageBloc extends Bloc<TagsPageEvent, TagsPageState> {
  final GetClickupTagsInSpaceUseCase _getClickupTagsInSpaceUseCase;
  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;
  final CreateClickupTagInSpaceUseCase _createClickupTagInSpaceUseCase;
  final UpdateClickupTagUseCase _updateClickupTagUseCase;
  final DeleteClickupTagUseCase _deleteClickupTagUseCase;
  TagsPageBloc(
      this._getClickupTagsInSpaceUseCase,
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._createClickupTagInSpaceUseCase,
      this._updateClickupTagUseCase,
      this._deleteClickupTagUseCase)
      : super(TagsPageInitial()) {
    on<TagsPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
