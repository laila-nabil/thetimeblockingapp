import 'package:equatable/equatable.dart';

class TaskStatus extends Equatable{
  final String? id;
  final String? name;
  final String? color;

  const TaskStatus({required this.id, required this.name, required this.color});

  @override
  List<Object?> get props => [id,name,color];
}