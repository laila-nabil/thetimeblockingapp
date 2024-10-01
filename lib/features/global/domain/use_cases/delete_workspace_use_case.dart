import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';

class DeleteWorkspaceParams extends Equatable {
  final Workspace workspace;

  DeleteWorkspaceParams(this.workspace);

  @override
  List<Object?> get props => [workspace];
}
