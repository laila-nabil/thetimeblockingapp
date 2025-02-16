import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

class TaskStatus extends Equatable {
  final String? id;
  final String? nameKey;
  final String? nameEn;
  final String? nameAr;
  final String? color;
  final bool? isDone;

  const TaskStatus(
      {required this.id,
      required this.nameKey,
      required this.nameAr,
      required this.nameEn,
      required this.color,
      required this.isDone});

  String? name(LanguagesEnum languageEnum){
    switch(languageEnum){
      case LanguagesEnum.ar:
        return nameAr;
      case LanguagesEnum.en:
        return nameEn;
      default:
        return nameKey;
    }
  }
  @override
  List<Object?> get props => [id, nameKey,nameAr,nameEn, color, isDone];

  Color? get getColor => HexColor.fromHex(color??"");
}

extension ExTaskStatus on List<TaskStatus>{
  TaskStatus? get completedStatus{
    return where((s)=>s.isDone == true).firstOrNull ;
  }

  TaskStatus? get todoStatus{
    return lastOrNull ;
  }
}