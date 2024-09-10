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
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
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
                  Uri(path: ListPage.routeName, queryParameters: {
                    ListPage.queryParametersList.first:
                        state.navigateList?.id ?? ""
                  }).toString(),
                  extra: listsPageBloc);
            } else if (state.listsPageStatus == ListsPageStatus.deleteListTry) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return CustomAlertDialog(
                      loading: false,
                      actions: [
                        CustomButton.noIcon(
                            label: appLocalization.translate("delete"),
                            onPressed: () {
                              listsPageBloc.add(DeleteListEvent.submit(
                                  deleteListParams:
                                      DeleteListParams(
                                          list: state.toDeleteList!,
                                          accessToken:
                                          authBloc.state.accessToken!),
                                  workspace:
                                      globalBloc.state.selectedWorkspace!,
                                  space: globalBloc.state.selectedSpace!,
                                  onSuccess: () {
                                    globalBloc.add(GetAllInWorkspaceEvent(
                                      accessToken: authBloc.state.accessToken!,
                                      workspace:
                                          globalBloc.state.selectedWorkspace!,
                                    ));
                                  }));
                              Navigator.pop(context);
                            },type: CustomButtonType.destructiveFilledLabel),
                        CustomButton.noIcon(
                            label: appLocalization.translate("cancel"),
                            onPressed: () {
                              listsPageBloc.add(
                                  DeleteListEvent.cancelDelete(onSuccess: () {
                                globalBloc.add(GetAllInWorkspaceEvent(
                                  accessToken: authBloc.state.accessToken!,
                                  workspace:
                                      globalBloc.state.selectedWorkspace!,
                                ));
                              }));
                              Navigator.pop(context);
                            }),
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
                            label: appLocalization.translate("delete"),
                            onPressed: () {
                              listsPageBloc.add(DeleteFolderEvent.submit(
                                  deleteFolderParams:
                                      DeleteFolderParams(
                                          folder: state.toDeleteFolder!,
                                          accessToken:
                                              authBloc.state.accessToken!),
                                  workspace:
                                      BlocProvider.of<GlobalBloc>(context)
                                          .state
                                          .selectedWorkspace!,
                                  space: BlocProvider.of<GlobalBloc>(context)
                                      .state
                                      .selectedSpace!,
                                  onSuccess: () {
                                    globalBloc.add(GetAllInWorkspaceEvent(
                                      accessToken: authBloc.state.accessToken!,
                                      workspace:
                                          globalBloc.state.selectedWorkspace!,
                                    ));
                                  }));
                              Navigator.pop(context);
                            },type: CustomButtonType.destructiveFilledLabel),
                        CustomButton.noIcon(
                            label: appLocalization.translate("cancel"),
                            onPressed: () {
                              listsPageBloc.add(
                                  DeleteFolderEvent.cancelDelete(onSuccess: () {
                                globalBloc.add(GetAllInWorkspaceEvent(
                                  accessToken: authBloc.state.accessToken!,
                                  workspace:
                                      globalBloc.state.selectedWorkspace!,
                                ));
                              }));
                              Navigator.pop(context);
                            }),
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
            if (state.canGetData(globalState.isLoading) && serviceLocator<bool>(instanceName:ServiceLocatorName.isWorkspaceAndSpaceAppWide.name)) {
              getListsFolders(listsPageBloc,authBloc.state,globalBloc);
            }
            return ResponsiveScaffold(
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: state.isLoading || startupState.isLoading),
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
                                      (globalState.selectedSpace?.folders
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
                                                            accessToken: authBloc.state.accessToken!,
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
                                                                accessToken: authBloc.state.accessToken!,
                                                                workspace: globalBloc.state.selectedWorkspace!,
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
                                                              accessToken: authBloc.state.accessToken!,
                                                              workspace: globalBloc.state.selectedWorkspace!,
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
                                                                    accessToken:
                                                                    authBloc.state
                                                                        .accessToken!,
                                                                    folder:
                                                                    folder,
                                                                    listName:
                                                                    text, user: authBloc.state.user!, space: globalState.selectedSpace!),
                                                                workspace:
                                                                globalState
                                                                    .selectedWorkspace!,
                                                                space:
                                                                globalState
                                                                    .selectedSpace!, onSuccess: () {
                                                              globalBloc.add(GetAllInWorkspaceEvent(
                                                                accessToken: authBloc.state.accessToken!,
                                                                workspace: globalBloc.state.selectedWorkspace!,
                                                              ));
                                                            }));
                                                          }, onCancel: () {
                                                        listsPageBloc.add(
                                                            CreateListInFolderEvent
                                                                .cancelCreate(onSuccess: (){
                                                              globalBloc.add(GetAllInWorkspaceEvent(
                                                                accessToken: authBloc.state.accessToken!,
                                                                workspace: globalBloc.state.selectedWorkspace!,
                                                              ));
                                                            }));
                                                      })
                                                  ]))
                                          .toList() ??
                                          []) +
                                      [
                                        ToggleableSection(
                                            title: appLocalization.translate("otherLists"),
                                            children: (globalState.selectedSpace?.lists
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
                                                            accessToken: authBloc.state.accessToken!,
                                                            workspace: globalBloc.state.selectedWorkspace!,
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
                                                    accessToken:
                                                    authBloc.state
                                                        .accessToken!,
                                                    folderName: text,
                                                    space: globalState
                                                        .selectedSpace!, user: authBloc.state.user!),
                                                workspace: globalState
                                                    .selectedWorkspace!,
                                                space: globalState
                                                    .selectedSpace!, onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                              accessToken: authBloc.state.accessToken!,
                                              workspace: globalBloc.state.selectedWorkspace!,
                                            )); }));
                                          },
                                          onCancel: () {
                                            listsPageBloc.add(
                                                CreateFolderInSpaceEvent
                                                    .cancelCreate(onSuccess: () { globalBloc.add(GetAllInWorkspaceEvent(
                                                  accessToken: authBloc.state.accessToken!,
                                                  workspace: globalBloc.state.selectedWorkspace!,
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
                                                  accessToken: authBloc.state.accessToken!,
                                                  workspace: globalBloc.state.selectedWorkspace!,
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
                                                  accessToken:
                                                  authBloc.state
                                                      .accessToken!,
                                                  listName: text,
                                                  space: globalState
                                                      .selectedSpace!, user: authBloc.state.user!),
                                              workspace: globalState
                                                  .selectedWorkspace!,
                                              space: globalState
                                                  .selectedSpace!,
                                                  onSuccess: () {
                                                    globalBloc.add(
                                                        GetAllInWorkspaceEvent(
                                                      accessToken: authBloc
                                                          .state.accessToken!,
                                                      workspace: globalBloc
                                                          .state
                                                          .selectedWorkspace!,
                                                    ));
                                                  }));
                                        }, onCancel: () {
                                          listsPageBloc.add(
                                              CreateListInFolderEvent
                                                  .cancelCreate(onSuccess: () {
                                                globalBloc.add(GetAllInWorkspaceEvent(
                                                  accessToken: authBloc.state.accessToken!,
                                                  workspace: globalBloc.state.selectedWorkspace!,
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
                                                        accessToken: authBloc
                                                            .state.accessToken!,
                                                        workspace: globalBloc
                                                            .state
                                                            .selectedWorkspace!,
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
      accessToken: authState.accessToken!,
      workspace: globalBloc.state.selectedWorkspace!,
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
