import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/localization/localization.dart';

class TaskPriority extends Equatable {
  final String? id;
  final String? color;
  final String? nameKey;
  final String? nameEn;
  final String? nameAr;

  Color? get getColor => HexColor.fromHex(color ?? "");

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
  TaskPriority({this.id, this.nameKey ,this.color, this.nameEn, this.nameAr});

  @override
  List<Object?> get props => [id, color,nameKey, nameAr, nameEn];
}
