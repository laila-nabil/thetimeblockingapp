import 'package:equatable/equatable.dart';

class Tag extends Equatable{
  final String? id;
  final String? name;
  final String? workspaceId;
  final String? color;

  const Tag({required this.id, required this.name, required this.workspaceId, required this.color});

  @override
  List<Object?> get props => [id,name,workspaceId,color];
}