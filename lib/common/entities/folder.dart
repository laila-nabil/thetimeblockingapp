import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/list_entity.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';

class Folder extends Equatable{
  const Folder({
      this.id, 
      this.name,
      this.spaceId,
      this.color,
      this.lists,});

  final String? id;
  final String? name;
  final String? spaceId;
  final String? color;
  final List<ListEntity>? lists;


  @override
  List<Object?> get props => [id,
    name,
    spaceId,
    lists,color];

  Folder copyWith({
    String? id,
    String? name,
    String? spaceId,
    String? color,
    List<ListEntity>? lists,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      spaceId: spaceId ?? this.spaceId,
      color: color ?? this.color,
      lists: lists ?? this.lists,
    );
  }
}