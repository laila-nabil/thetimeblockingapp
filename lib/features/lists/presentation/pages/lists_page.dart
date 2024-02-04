import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_alert_dialog.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_text_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/list_component.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/toggleable_section.dart';

import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../bloc/lists_page_bloc.dart';

///FIXME in drawerLargerScreenOpen mode error: Expected a value of type 'Widget', but got one of type 'Null'

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  static const routeName = "/Lists";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ListsPageBloc>(),
      child: BlocBuilder<StartupBloc, StartupState>(
          builder: (context, startupState) {
        return BlocConsumer<ListsPageBloc, ListsPageState>(
          listener: (context, state) {
            final listsPageBloc = BlocProvider.of<ListsPageBloc>(context);
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
                              listsPageBloc.add(DeleteClickupListEvent.submit(
                                  deleteClickupListParams:
                                      DeleteClickupListParams(
                                          list: state.toDeleteList!,
                                          clickupAccessToken:
                                              Globals.clickupAuthAccessToken),
                                  clickupWorkspace: Globals.selectedWorkspace!,
                                  clickupSpace: Globals.selectedSpace!));
                              Navigator.pop(context);
                            }),
                        CustomButton.noIcon(
                            label: appLocalization.translate("cancel"),
                            onPressed: () {
                              listsPageBloc
                                  .add(DeleteClickupListEvent.cancelDelete());
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
                              listsPageBloc.add(DeleteClickupFolderEvent.submit(
                                  deleteClickupFolderParams:
                                      DeleteClickupFolderParams(
                                          folder: state.toDeleteFolder!,
                                          clickupAccessToken:
                                              Globals.clickupAuthAccessToken),
                                  clickupWorkspace: Globals.selectedWorkspace!,
                                  clickupSpace: Globals.selectedSpace!));
                              Navigator.pop(context);
                            }),
                        CustomButton.noIcon(
                            label: appLocalization.translate("cancel"),
                            onPressed: () {
                              listsPageBloc
                                  .add(DeleteClickupFolderEvent.cancelDelete());
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
            final startupBloc = BlocProvider.of<StartupBloc>(context);
            return ResponsiveScaffold(
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: state.isLoading || startupState.isLoading),
                responsiveBody: ResponsiveTParams(
                    small: BlocConsumer<ListsPageBloc, ListsPageState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.isInit && Globals.isSpaceAppWide) {
                      getListsFolders(listsPageBloc);
                    }
                    return Padding(
                      padding: EdgeInsets.all(AppSpacing.medium16.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSpacing.medium16.value),
                            child: Text(
                              appLocalization.translate("Lists"),
                              style: AppTextStyle.getTextStyle(
                                  AppTextStyleParams(
                                      color: AppColors.grey.shade900,
                                      appFontWeight: AppFontWeight.medium,
                                      appFontSize: AppFontSize.heading4)),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: <Widget>[] +
                                  (Globals.selectedSpace?.folders
                                          .map<Widget>((folder) => true
                                              ? ToggleableSection(
                                                  actions: [
                                                      CustomDropDownItem.text(
                                                          title: appLocalization
                                                              .translate(
                                                                  "delete"),
                                                          onTap: () {
                                                            listsPageBloc.add(
                                                                DeleteClickupFolderEvent
                                                                    .tryDelete(
                                                                        folder));
                                                          })
                                                    ],
                                                  title: folder.name ?? "",
                                                  children: folder.lists
                                                          ?.map<Widget>(
                                                              (e) =>
                                                                  ListComponent(
                                                                    list: e,
                                                                    actions: [
                                                                      CustomDropDownItem.text(
                                                                          title: appLocalization.translate("delete"),
                                                                          onTap: () {
                                                                            listsPageBloc.add(DeleteClickupListEvent.tryDelete(e));
                                                                          })
                                                                    ],
                                                                  ))
                                                          .toList() ??
                                                      [])
                                              : ExpansionTile(
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  title: Row(
                                                    children: [
                                                      const Icon(Icons.folder),
                                                      Text(folder.name ?? ""),
                                                      const Spacer(),
                                                      PopupMenuButton(
                                                          icon: const Icon(
                                                              Icons.more_horiz),
                                                          itemBuilder:
                                                              (ctx) => [
                                                                    PopupMenuItem(
                                                                        onTap:
                                                                            () {
                                                                          listsPageBloc
                                                                              .add(DeleteClickupFolderEvent.tryDelete(folder));
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.delete),
                                                                            Text(appLocalization.translate("delete")),
                                                                          ],
                                                                        ))
                                                                  ])
                                                    ],
                                                  ),
                                                  children: (folder.lists
                                                              ?.map((e) =>
                                                                  ListTile(
                                                                      onTap:
                                                                          () {
                                                                        listsPageBloc
                                                                            .add(NavigateToListPageEvent(e));
                                                                      },
                                                                      title:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.list),
                                                                          Text(e.name ??
                                                                              ""),
                                                                          const Spacer(),
                                                                          PopupMenuButton(
                                                                              icon: const Icon(Icons.more_horiz),
                                                                              itemBuilder: (ctx) => [
                                                                                    PopupMenuItem(
                                                                                        onTap: () {
                                                                                          listsPageBloc.add(DeleteClickupListEvent.tryDelete(e));
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            const Icon(Icons.delete),
                                                                                            Text(appLocalization.translate("delete")),
                                                                                          ],
                                                                                        ))
                                                                                  ])
                                                                        ],
                                                                      )))
                                                              .toList() ??
                                                          []) +
                                                      [
                                                        state.tryCreateListInFolder(
                                                                folder)
                                                            ? ListTile(
                                                                title: _CreateField(
                                                                    onAdd:
                                                                        (text) {
                                                                  listsPageBloc.add(CreateListInFolderEvent.submit(
                                                                      createClickupListInFolderParams: CreateClickupListInFolderParams(
                                                                          clickupAccessToken: Globals
                                                                              .clickupAuthAccessToken,
                                                                          clickupFolder:
                                                                              folder,
                                                                          listName:
                                                                              text),
                                                                      clickupWorkspace:
                                                                          Globals
                                                                              .selectedWorkspace!,
                                                                      clickupSpace:
                                                                          Globals
                                                                              .selectedSpace!));
                                                                }, onCancel:
                                                                        () {
                                                                  listsPageBloc.add(
                                                                      CreateListInFolderEvent
                                                                          .cancelCreate());
                                                                }),
                                                              )
                                                            : ListTile(
                                                                title:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          listsPageBloc
                                                                              .add(CreateListInFolderEvent.tryCreate(folderToCreateListIn: folder));
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(appLocalization.translate("createNewList")),
                                                                          ],
                                                                        )),
                                                              )
                                                      ],
                                                ))
                                          .toList() ??
                                      []) +
                                  ((Globals.selectedSpace?.lists
                                              .map((e) => ListTile(
                                                  onTap: () {
                                                    listsPageBloc.add(
                                                        NavigateToListPageEvent(
                                                            e));
                                                  },
                                                  title: Row(
                                                    children: [
                                                      const Icon(Icons.list),
                                                      Expanded(
                                                          child: Text(
                                                              e.name ?? "")),
                                                      PopupMenuButton(
                                                          icon: const Icon(
                                                              Icons.more_horiz),
                                                          onSelected: (_) =>
                                                              Navigator.pop(
                                                                  context),
                                                          itemBuilder:
                                                              (ctx) => [
                                                                    PopupMenuItem(
                                                                        onTap:
                                                                            () {
                                                                          listsPageBloc
                                                                              .add(DeleteClickupListEvent.tryDelete(e));
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.delete),
                                                                            Text(appLocalization.translate("delete")),
                                                                          ],
                                                                        ))
                                                                  ]),
                                                    ],
                                                  )))
                                              .toList() ??
                                          []) +
                                      [
                                        state.tryCreateFolderInSpace
                                            ? ListTile(
                                                title:
                                                    _CreateField(onAdd: (text) {
                                                  listsPageBloc.add(CreateClickupFolderInSpaceEvent.submit(
                                                      createClickupFolderInSpaceParams:
                                                          CreateClickupFolderInSpaceParams(
                                                              clickupAccessToken:
                                                                  Globals
                                                                      .clickupAuthAccessToken,
                                                              folderName: text,
                                                              clickupSpace: Globals
                                                                  .selectedSpace!),
                                                      clickupWorkspace: Globals
                                                          .selectedWorkspace!,
                                                      clickupSpace: Globals
                                                          .selectedSpace!));
                                                }, onCancel: () {
                                                  listsPageBloc.add(
                                                      CreateClickupFolderInSpaceEvent
                                                          .cancelCreate());
                                                }),
                                              )
                                            : ListTile(
                                                title: TextButton(
                                                    onPressed: () {
                                                      listsPageBloc.add(
                                                          CreateClickupFolderInSpaceEvent
                                                              .tryCreate());
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(appLocalization
                                                            .translate(
                                                                "createNewFolder")),
                                                      ],
                                                    )),
                                              )
                                      ] +
                                      [
                                        state.tryCreateListInSpace
                                            ? ListTile(
                                                title:
                                                    _CreateField(onAdd: (text) {
                                                  listsPageBloc.add(CreateFolderlessListEvent.submit(
                                                      createFolderlessListClickupParams:
                                                          CreateFolderlessListClickupParams(
                                                              clickupAccessToken:
                                                                  Globals
                                                                      .clickupAuthAccessToken,
                                                              listName: text,
                                                              clickupSpace: Globals
                                                                  .selectedSpace!),
                                                      clickupWorkspace: Globals
                                                          .selectedWorkspace!,
                                                      clickupSpace: Globals
                                                          .selectedSpace!));
                                                }, onCancel: () {
                                                  listsPageBloc.add(
                                                      CreateListInFolderEvent
                                                          .cancelCreate());
                                                }),
                                              )
                                            : ListTile(
                                                title: TextButton(
                                                    onPressed: () {
                                                      listsPageBloc.add(
                                                          CreateFolderlessListEvent
                                                              .tryCreate());
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(appLocalization
                                                            .translate(
                                                                "createNewList")),
                                                      ],
                                                    )),
                                              )
                                      ]),
                            ),
                          )
                        ],
                      ),
                    );
                    return SingleChildScrollView(
                      child: Column(
                          children: <Widget>[] +
                              (Globals.selectedSpace?.folders
                                      .map((folder) => ExpansionTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Row(
                                              children: [
                                                const Icon(Icons.folder),
                                                Text(folder.name ?? ""),
                                                const Spacer(),
                                                PopupMenuButton(
                                                    icon: const Icon(
                                                        Icons.more_horiz),
                                                    itemBuilder: (ctx) => [
                                                          PopupMenuItem(
                                                              onTap: () {
                                                                listsPageBloc.add(
                                                                    DeleteClickupFolderEvent
                                                                        .tryDelete(
                                                                            folder));
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(Icons
                                                                      .delete),
                                                                  Text(appLocalization
                                                                      .translate(
                                                                          "delete")),
                                                                ],
                                                              ))
                                                        ])
                                              ],
                                            ),
                                            children: (folder.lists
                                                        ?.map((e) => ListTile(
                                                            onTap: () {
                                                              listsPageBloc.add(
                                                                  NavigateToListPageEvent(
                                                                      e));
                                                            },
                                                            title: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.list),
                                                                Text(e.name ??
                                                                    ""),
                                                                const Spacer(),
                                                                PopupMenuButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .more_horiz),
                                                                    itemBuilder:
                                                                        (ctx) =>
                                                                            [
                                                                              PopupMenuItem(
                                                                                  onTap: () {
                                                                                    listsPageBloc.add(DeleteClickupListEvent.tryDelete(e));
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Icon(Icons.delete),
                                                                                      Text(appLocalization.translate("delete")),
                                                                                    ],
                                                                                  ))
                                                                            ])
                                                              ],
                                                            )))
                                                        .toList() ??
                                                    []) +
                                                [
                                                  state.tryCreateListInFolder(
                                                          folder)
                                                      ? ListTile(
                                                          title: _CreateField(
                                                              onAdd: (text) {
                                                            listsPageBloc.add(CreateListInFolderEvent.submit(
                                                                createClickupListInFolderParams: CreateClickupListInFolderParams(
                                                                    clickupAccessToken:
                                                                        Globals
                                                                            .clickupAuthAccessToken,
                                                                    clickupFolder:
                                                                        folder,
                                                                    listName:
                                                                        text),
                                                                clickupWorkspace:
                                                                    Globals
                                                                        .selectedWorkspace!,
                                                                clickupSpace:
                                                                    Globals
                                                                        .selectedSpace!));
                                                          }, onCancel: () {
                                                            listsPageBloc.add(
                                                                CreateListInFolderEvent
                                                                    .cancelCreate());
                                                          }),
                                                        )
                                                      : ListTile(
                                                          title: TextButton(
                                                              onPressed: () {
                                                                listsPageBloc.add(
                                                                    CreateListInFolderEvent.tryCreate(
                                                                        folderToCreateListIn:
                                                                            folder));
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(appLocalization
                                                                      .translate(
                                                                          "createNewList")),
                                                                ],
                                                              )),
                                                        )
                                                ],
                                          ))
                                      .toList() ??
                                  []) +
                              ((Globals.selectedSpace?.lists
                                          .map((e) => ListTile(
                                              onTap: () {
                                                listsPageBloc.add(
                                                    NavigateToListPageEvent(e));
                                              },
                                              title: Row(
                                                children: [
                                                  const Icon(Icons.list),
                                                  Expanded(
                                                      child:
                                                          Text(e.name ?? "")),
                                                  PopupMenuButton(
                                                      icon: const Icon(
                                                          Icons.more_horiz),
                                                      onSelected: (_) =>
                                                          Navigator.pop(
                                                              context),
                                                      itemBuilder: (ctx) => [
                                                            PopupMenuItem(
                                                                onTap: () {
                                                                  listsPageBloc.add(
                                                                      DeleteClickupListEvent
                                                                          .tryDelete(
                                                                              e));
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(Icons
                                                                        .delete),
                                                                    Text(appLocalization
                                                                        .translate(
                                                                            "delete")),
                                                                  ],
                                                                ))
                                                          ]),
                                                ],
                                              )))
                                          .toList() ??
                                      []) +
                                  [
                                    state.tryCreateFolderInSpace
                                        ? ListTile(
                                            title: _CreateField(onAdd: (text) {
                                              listsPageBloc.add(CreateClickupFolderInSpaceEvent.submit(
                                                  createClickupFolderInSpaceParams:
                                                      CreateClickupFolderInSpaceParams(
                                                          clickupAccessToken:
                                                              Globals
                                                                  .clickupAuthAccessToken,
                                                          folderName: text,
                                                          clickupSpace: Globals
                                                              .selectedSpace!),
                                                  clickupWorkspace: Globals
                                                      .selectedWorkspace!,
                                                  clickupSpace:
                                                      Globals.selectedSpace!));
                                            }, onCancel: () {
                                              listsPageBloc.add(
                                                  CreateClickupFolderInSpaceEvent
                                                      .cancelCreate());
                                            }),
                                          )
                                        : ListTile(
                                            title: TextButton(
                                                onPressed: () {
                                                  listsPageBloc.add(
                                                      CreateClickupFolderInSpaceEvent
                                                          .tryCreate());
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(appLocalization
                                                        .translate(
                                                            "createNewFolder")),
                                                  ],
                                                )),
                                          )
                                  ] +
                                  [
                                    state.tryCreateListInSpace
                                        ? ListTile(
                                            title: _CreateField(onAdd: (text) {
                                              listsPageBloc.add(CreateFolderlessListEvent.submit(
                                                  createFolderlessListClickupParams:
                                                      CreateFolderlessListClickupParams(
                                                          clickupAccessToken:
                                                              Globals
                                                                  .clickupAuthAccessToken,
                                                          listName: text,
                                                          clickupSpace: Globals
                                                              .selectedSpace!),
                                                  clickupWorkspace: Globals
                                                      .selectedWorkspace!,
                                                  clickupSpace:
                                                      Globals.selectedSpace!));
                                            }, onCancel: () {
                                              listsPageBloc.add(
                                                  CreateListInFolderEvent
                                                      .cancelCreate());
                                            }),
                                          )
                                        : ListTile(
                                            title: TextButton(
                                                onPressed: () {
                                                  listsPageBloc.add(
                                                      CreateFolderlessListEvent
                                                          .tryCreate());
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(appLocalization
                                                        .translate(
                                                            "createNewList")),
                                                  ],
                                                )),
                                          )
                                  ])),
                    );
                  },
                )),
                context: context);
          },
        );
      }),
    );
  }

  void getListsFolders(ListsPageBloc listsPageBloc) {
    listsPageBloc.add(GetListAndFoldersInListsPageEvent.inWorkSpace(
      clickupAccessToken: Globals.clickupAuthAccessToken,
      clickupWorkspace: Globals.selectedWorkspace!,
    ));
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
