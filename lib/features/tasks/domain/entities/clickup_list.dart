
import 'package:equatable/equatable.dart';

/// id : "1"
/// name : "List"
/// access : true

class ClickupList extends Equatable {
  const ClickupList({
    this.id,
    this.name,
    this.access,
  });

  final String? id;
  final String? name;
  final bool? access;

  @override
  List<Object?> get props => [
    id,
    name,
    access,
  ];
}