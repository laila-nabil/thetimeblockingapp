
import 'package:equatable/equatable.dart';

class ListEntity extends Equatable {
  const ListEntity({
    this.id,
    this.name,
    this.spaceId,
    this.folderId,
    this.color,
  });

  final String? id;
  final String? name;
  final String? spaceId;
  final String? folderId;
  final String? color;

  @override
  List<Object?> get props => [
    id,
    name,
    spaceId,
    folderId,
    color,
  ];

}