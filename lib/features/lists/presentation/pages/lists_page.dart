import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/list_component.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/toggleable_section.dart';

import '../../../../common/widgets/custom_pop_up_menu.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../global/presentation/bloc/global_bloc.dart';
import '../bloc/lists_page_bloc.dart';


class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  static const routeName = "/Lists";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ListsPageBloc>(),
      child: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, startupState) {
        return BlocConsumer<ListsPageBloc, ListsPageState>(
          listener: (context, state) {
            final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
            final authBloc = BlocProvider.of<AuthBloc>(context);
            var globalBloc = BlocProvider.of<GlobalBloc>(context);
            if (state.listsPageStatus == ListsPageStatus.navigateList &&
                state.navigateList != null) {
              context.push(
                  Uri(path: ListPage.routeName).toString(),
                  extra: [listsPageBloc ,state.navigateList ]);
            } else if (state.listsPageStatus == ListsPageStatus.deleteListTry) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return CustomAlertDialog(
                      loading: false,
                      actions: [
                        CustomButton.noIcon(
                          type: CustomButtonType.greyTextLabel,
                          label: appLocalization.translate("cancel"),
                          onPressed: () {
                            listsPageBloc.add(
                                DeleteListEvent.cancelDelete(onSuccess: () {
                                  globalBloc.add(GetAllInWorkspaceEvent(

                                      workspace:
                                      globalBloc.state.selectedWorkspace!
                                      , user: authBloc.state.user!
                                  ));
                                }));
                            Navigator.pop(context);
                          }),
                        CustomButton.noIcon(
                            label: appLocalization.translate("delete"),
                            onPressed: () {
                              listsPageBloc.add(DeleteListEvent.submit(
                                  deleteListParams:
                                      DeleteListParams(
                                          list: state.toDeleteList!,
                                          ),
                                  workspace:
                                      globalBloc.state.selectedWorkspace!,
                                  onSuccess: () {
                                    globalBloc.add(GetAllInWorkspaceEvent(
                                      
                                      workspace:
                                          globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                    ));
                                  }));
                              Navigator.pop(context);
                            },type: CustomButtonType.destructiveFilledLabel),
                      ],
                      content: Text(
                          "${appLocalization.translate("areYouSureDelete")} ${state.toDeleteList?.name}?"),
                    );
                  });
            } else if (state.listsPageStatus ==
                ListsPageStatus.deleteFolderTry) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return CustomAlertDialog(
                      loading: false,
                      actions: [
                        CustomButton.noIcon(
                            type: CustomButtonType.greyTextLabel,
                            label: appLocalization.translate("cancel"),
                            onPressed: () {
                              listsPageBloc.add(
                                  DeleteFolderEvent.cancelDelete(onSuccess: () {
                                    globalBloc.add(GetAllInWorkspaceEvent(

                                        workspace:
                                        globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                    ));
                                  }));
                              Navigator.pop(context);
                            }),
                        CustomButton.noIcon(
                            label: appLocalization.translate("delete"),
                            onPressed: () {
                              listsPageBloc.add(DeleteFolderEvent.submit(
                                  deleteFolderParams:
                                      DeleteFolderParams(
                                          folder: state.toDeleteFolder!,),
                                  workspace:
                                      BlocProvider.of<GlobalBloc>(context)
                                          .state
                                          .selectedWorkspace!,
                                  onSuccess: () {
                                    globalBloc.add(GetAllInWorkspaceEvent(
                                      
                                      workspace:
                                          globalBloc.state.selectedWorkspace!
                                        , user: authBloc.state.user!
                                    ));
                                  }));
                              Navigator.pop(context);
                            },type: CustomButtonType.destructiveFilledLabel),
                      ],
                      content: Text(
                          "${appLocalization.translate("areYouSureDelete")} ${state.toDeleteFolder?.name}?"),
                    );
                  });
            }
          },
          builder: (context, state) {
            final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
            final globalBloc = BlocProvider.of<GlobalBloc>(context);
            final authBloc = BlocProvider.of<AuthBloc>(context);
            var globalState = BlocProvider.of<GlobalBloc>(context).state;
            if (state.canGetData(globalState.isLoading) && serviceLocator<AppConfig>().isWorkspaceAppWide) {
              getListsFolders(listsPageBloc,authBloc.state,globalBloc);
            }
            return ResponsiveScaffold(
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: state.isLoading ||
                      startupState.isLoading ||
                      globalState.workspaces == null),
              responsiveBody: ResponsiveTParams(
                    small: Padding(
                      padding: EdgeInsets.all(AppSpacing.medium16.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSpacing.medium16.value),
                            margin: EdgeInsets.only(
                                bottom: AppSpacing.medium16.value),
                            child: Text(
                              appLocalization.translate("Lists"),
                              style: AppTextStyle.getTextStyle(
                                  AppTextStyleParams(
                                      color: AppColors.grey(context.isDarkMode).shade900,
                                      appFontWeight: AppFontWeight.medium,
                                      appFontSize: AppFontSize.heading4)),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[] +
                                      (globalState.selectedWorkspace?.folders
                                          ?.map<Widget>((folder) =>
                                          ToggleableSection(
                                              actions: [
                                                CustomPopupItem(
                                                    title: appLocalization
                                                        .translate(
                                                        "delete"),
                                                    onTap: () {
                                                      listsPageBloc.add(
                                                          DeleteFolderEvent
                                                              .tryDelete(
                                                              folder, onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                                             user: authBloc.state.user!,
                                                            workspace: globalBloc.state.selectedWorkspace!,
                                                          )); }));
                                                    })
                                              ],
                                              title: folder.name ?? "",
                                              buttons: [
                                                if (state
                                                    .tryCreateListInFolder(
                                                    folder) ==
                                                    false)
                                                  ToggleableSectionButtonParams(
                                                      title:
                                                      "+ ${appLocalization.translate("createNewList")}",
                                                      onTap: () {
                                                        listsPageBloc.add(
                                                            CreateListInFolderEvent
                                                                .tryCreate(
                                                                folderToCreateListIn:
                                                                folder, onSuccess: () {
                                                              globalBloc.add(GetAllInWorkspaceEvent(
                                                                
                                                                workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                              ));
                                                            }));
                                                      })
                                              ],
                                              children: (folder.lists
                                                  ?.map<Widget>((e) =>
                                                  ListComponent(
                                                    onTap: () {
                                                      listsPageBloc.add(
                                                          NavigateToListPageEvent(
                                                              e));
                                                    },
                                                    list: e,
                                                    actions: [
                                                      CustomPopupItem(
                                                          title: appLocalization.translate("delete"),
                                                          onTap: () {
                                                            listsPageBloc.add(DeleteListEvent.tryDelete(e, onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                                              
                                                              workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                            )); }));
                                                          })
                                                    ],
                                                  ))
                                                  .toList() ??
                                                  []) +
                                                  [
                                                    if (state
                                                        .tryCreateListInFolder(
                                                        folder))
                                                      _CreateField(
                                                          onAdd: (text) {
                                                            listsPageBloc.add(CreateListInFolderEvent.submit(
                                                                createListInFolderParams: CreateListInFolderParams(

                                                                    folder:
                                                                    folder,
                                                                    listName:
                                                                    text, user: authBloc.state.user!, workspace: globalState.selectedWorkspace!),
                                                                workspace:
                                                                globalState
                                                                    .selectedWorkspace!,
                                                                onSuccess: () {
                                                              globalBloc.add(GetAllInWorkspaceEvent(
                                                                
                                                                workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                              ));
                                                            }));
                                                          }, onCancel: () {
                                                        listsPageBloc.add(
                                                            CreateListInFolderEvent
                                                                .cancelCreate(onSuccess: (){
                                                              globalBloc.add(GetAllInWorkspaceEvent(
                                                                
                                                                workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                              ));
                                                            }));
                                                      })
                                                  ]))
                                          .toList() ??
                                          []) +
                                      [
                                        ToggleableSection(
                                            title: appLocalization.translate("otherLists"),
                                            children: (globalState.selectedWorkspace?.lists
                                                ?.map<Widget>((e) => ListComponent(
                                              list: e,
                                              actions: [
                                                CustomPopupItem(
                                                    title: appLocalization
                                                        .translate(
                                                        "delete"),
                                                    onTap: () {
                                                      listsPageBloc.add(
                                                          DeleteListEvent
                                                              .tryDelete(
                                                              e, onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                                            
                                                            workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                          )); }));
                                                    })
                                              ],
                                              onTap: () {
                                                listsPageBloc.add(
                                                    NavigateToListPageEvent(
                                                        e));
                                              },
                                            ))
                                                .toList() ??
                                                []))
                                      ] +
                                      <Widget>[
                                        state.tryCreateFolderInSpace
                                            ? _CreateField(
                                          onAdd: (text) {
                                            listsPageBloc.add(CreateFolderInSpaceEvent.submit(
                                                createFolderInSpaceParams:
                                                CreateFolderInSpaceParams(

                                                    folderName: text,
                                                    workspace: globalState
                                                        .selectedWorkspace!, user: authBloc.state.user!),
                                                workspace: globalState
                                                    .selectedWorkspace!,
                                                onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                              
                                              workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                            )); }));
                                          },
                                          onCancel: () {
                                            listsPageBloc.add(
                                                CreateFolderInSpaceEvent
                                                    .cancelCreate(onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                                  
                                                  workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                )); }));
                                          },
                                        )
                                            : CustomButton.noIcon(
                                          label:
                                          "+ ${appLocalization.translate("createNewFolder")}",
                                          onPressed: () {
                                            listsPageBloc.add(
                                                CreateFolderInSpaceEvent
                                                    .tryCreate(onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                                  
                                                  workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                )); }));
                                          },
                                          type: CustomButtonType
                                              .greyTextLabel,
                                        )
                                      ] +
                                      <Widget>[
                                        state.tryCreateListInSpace
                                            ? _CreateField(onAdd: (text) {
                                          listsPageBloc.add(CreateFolderlessListEvent.submit(
                                              createFolderlessListParams:
                                              CreateFolderlessListParams(

                                                  listName: text,
                                                  workspace: globalState
                                                      .selectedWorkspace!, user: authBloc.state.user!),
                                              workspace: globalState
                                                  .selectedWorkspace!,
                                                  onSuccess: () {
                                                    globalBloc.add(
                                                        GetAllInWorkspaceEvent(

                                                      workspace: globalBloc
                                                          .state
                                                          .selectedWorkspace!
                                                            , user: authBloc.state.user!
                                                    ));
                                                  }));
                                        }, onCancel: () {
                                          listsPageBloc.add(
                                              CreateListInFolderEvent
                                                  .cancelCreate(onSuccess: () {
                                                globalBloc.add(GetAllInWorkspaceEvent(
                                                  
                                                  workspace: globalBloc.state.selectedWorkspace!, user: authBloc.state.user!
                                                ));
                                              }));
                                        })
                                            : CustomButton.noIcon(
                                          label:
                                          "+ ${appLocalization.translate("createNewList")}",
                                          onPressed: () {
                                            listsPageBloc.add(
                                                CreateFolderlessListEvent
                                                    .tryCreate(onSuccess: () {
                                                  globalBloc.add(
                                                      GetAllInWorkspaceEvent(

                                                        workspace: globalBloc
                                                            .state
                                                            .selectedWorkspace!
                                                          , user: authBloc.state.user!
                                                      ));
                                                }));
                                          },
                                          type: CustomButtonType
                                              .greyTextLabel,
                                        )
                                      ]),
                            ),
                          )
                        ],
                      ),
                    )),
                context: context, onRefresh: ()async {
              getListsFolders(listsPageBloc,authBloc.state,globalBloc);
            },);
          },
        );
      }),
    );
  }

  void getListsFolders(ListsPageBloc listsPageBloc,AuthState authState,GlobalBloc globalBloc) {
    globalBloc.add(GetAllInWorkspaceEvent(
      workspace: globalBloc.state.selectedWorkspace!
        , user: authState.user!
    ));
    listsPageBloc.add(TryGetDataEvent());
  }
}

class _CreateField extends StatelessWidget {
  _CreateField({required this.onAdd, required this.onCancel});

  final TextEditingController controller = TextEditingController();
  final void Function(String text) onAdd;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextInputField(
          focusNode: FocusNode(),
          controller: controller,
        )),
        IconButton(icon: const Icon(Icons.cancel), onPressed: onCancel),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAdd(controller.text);
              }
            })
      ],
    );
  }
}
