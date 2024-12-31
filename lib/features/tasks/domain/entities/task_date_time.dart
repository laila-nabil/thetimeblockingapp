import 'package:equatable/equatable.dart';

class TaskDateTime extends Equatable {
  final DateTime? dateTime;
  final bool cleared;

  TaskDateTime({required this.dateTime, this.cleared = false});

  @override
  List<Object?> get props => [dateTime, cleared];
}