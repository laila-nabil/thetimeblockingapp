part of 'all_tasks_bloc.dart';

enum AllTasksStatus {
  initial,
  loading,
  getTasksSuccess,
  getTasksFailure,
  createTaskSuccess,
  createTaskFailed,
  updateTaskSuccess,
  updateTaskFailed,
  deleteTaskTry,
  deleteTaskSuccess,
  deleteTaskFailed,
}

class AllTasksState extends Equatable {
  final AllTasksStatus allTasksStatus;
  final List<Task>? allTasksResult;
  final Failure? createTaskFailure;
  final Failure? updateTaskFailure;
  final Failure? deleteTaskFailure;

  const AllTasksState(
      {required this.allTasksStatus,
      this.allTasksResult,
      this.createTaskFailure,
      this.updateTaskFailure,
      this.deleteTaskFailure});

  @override
  List<Object?> get props => [
        allTasksStatus,
        allTasksResult,
        createTaskFailure,
        updateTaskFailure,
        deleteTaskFailure
      ];

  List<Task> get getAllTasksResultOverdue =>
      allTasksResult
          ?.where((element) =>
              element.isOverdue )
          .toList() ??
      [];

  List<Task> get getAllTasksResultCompleted =>
      allTasksResult
          ?.where((element) => element.isCompleted)
          .toList() ??
          [];

  List<Task> get getAllTasksResultUpcoming =>
      allTasksResult?.where((element) => element.isUpcoming).toList() ?? [];

  List<Task> get getAllTasksResultUnscheduled =>
      allTasksResult?.where((element) => element.isUnscheduled).toList() ?? [];

  bool get isLoading => allTasksStatus == AllTasksStatus.loading;

  bool get isInit => allTasksStatus == AllTasksStatus.initial;

  AllTasksState copyWith({
    AllTasksStatus? allTasksStatus,
    List<Task>? allTasksResult,
    Failure? createTaskFailure,
    Failure? updateTaskFailure,
    Failure? deleteTaskFailure,
  }) {
    return AllTasksState(
      allTasksStatus: allTasksStatus ?? this.allTasksStatus,
      allTasksResult: allTasksResult ?? this.allTasksResult,
      createTaskFailure: createTaskFailure ?? this.createTaskFailure,
      updateTaskFailure: updateTaskFailure ?? this.updateTaskFailure,
      deleteTaskFailure: deleteTaskFailure ?? this.deleteTaskFailure,
    );
  }
}
