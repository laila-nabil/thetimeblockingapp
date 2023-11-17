import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_button.dart';
import 'package:thetimeblockingapp/common/widgets/custom_input_field.dart';
import 'package:thetimeblockingapp/common/widgets/responsive/responsive_scaffold.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/features/lists/presentation/pages/list_page.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_folder_in_spacce_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../core/localization/localization.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../bloc/lists_page_bloc.dart';

class ListsPage extends StatelessWidget {
  ListsPage({super.key});

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
              context.push(Uri(path: ListPage.routeName, queryParameters: {
                ListPage.queryParametersList.first: state.navigateList?.id ?? ""
              }).toString(),extra: listsPageBloc);
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
                    mobile: BlocConsumer<ListsPageBloc, ListsPageState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state.isInit && Globals.isSpaceAppWide) {
                          listsPageBloc.add(GetListAndFoldersInListsPageEvent.inWorkSpace(
                            clickupAccessToken: Globals.clickupAuthAccessToken,
                            clickupWorkspace: Globals.selectedWorkspace!,
                          ));
                        }
                        return SingleChildScrollView(
                          child: Column(
                              children: <Widget>[
                                if (Globals.isSpaceAppWide == false &&
                                    Globals.clickupSpaces?.isNotEmpty == true)
                                  DropdownButton<ClickupSpace?>(
                                    value: Globals.selectedSpace,
                                    onChanged: (selected) {
                                      if (selected != null && state.isLoading == false) {
                                        startupBloc.add(SelectClickupSpace(
                                            clickupSpace: selected,
                                            clickupAccessToken:
                                            Globals.clickupAuthAccessToken));
                                        listsPageBloc.add(
                                            GetListAndFoldersInListsPageEvent.inSpace(
                                                clickupAccessToken:
                                                Globals.clickupAuthAccessToken,
                                                clickupWorkspace:
                                                Globals.selectedWorkspace!,
                                                clickupSpace: selected));
                                      }
                                    },
                                    items: Globals.clickupSpaces
                                        ?.map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name ?? ""),
                                    ))
                                        .toList() ??
                                        [],
                                    hint: Text(appLocalization.translate("spaces")),
                                  ),
                              ] +
                                  (Globals.selectedSpace?.folders
                                      .map((folder) => ExpansionTile(
                                    title: Row(
                                      children: [
                                        const Icon(Icons.folder),
                                        Text(folder.name ?? ""),
                                      ],
                                    ),
                                    children: (folder.lists
                                        ?.map((e) => ListTile(
                                        onTap: () {
                                          listsPageBloc.add(NavigateToListPageEvent(e));
                                        },
                                        title: Row(
                                          children: [
                                            const Icon(Icons.list),
                                            Text(e.name ?? ""),
                                          ],
                                        )))
                                        .toList() ??
                                        [])+
                                        [
                                          state.tryCreateListInFolder(folder)
                                              ? ListTile(
                                                          title:
                                                              _CreateListInFolder(
                                                            listsPageBloc:
                                                                listsPageBloc,
                                                            folder: folder,
                                                          ),
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
                                        listsPageBloc.add(NavigateToListPageEvent(e));
                                      },
                                      title: Row(
                                        children: [
                                          const Icon(Icons.list),
                                          Text(e.name ?? ""),
                                        ],
                                      )))
                                      .toList() ??
                                      [])+[
                                    state.tryCreateFolderInSpace
                                        ? ListTile(
                                      title: _CreateFolderInSpace(
                                          listsPageBloc: listsPageBloc),
                                    )
                                        : ListTile(
                                      title: TextButton(
                                          onPressed: () {
                                            listsPageBloc.add(CreateClickupFolderInSpaceEvent.tryCreate());
                                          },
                                          child: Row(
                                            children: [
                                              Text(appLocalization.translate("createNewFolder")),
                                            ],
                                          )),
                                    )
                                  ]+[
                                    state.tryCreateListInSpace
                                        ? ListTile(
                                            title: _CreateListInSpace(
                                                listsPageBloc: listsPageBloc),
                                          )
                                        : ListTile(
                                      title: TextButton(
                                          onPressed: () {
                                            listsPageBloc.add(CreateFolderlessListEvent.tryCreate());
                                          },
                                          child: Row(
                                            children: [
                                              Text(appLocalization.translate("createNewList")),
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
}

class _CreateListInFolder extends StatelessWidget {
  _CreateListInFolder({
    required this.listsPageBloc,
    required this.folder,

  });
  final TextEditingController createNewList = TextEditingController();
  final ListsPageBloc listsPageBloc;
  final ClickupFolder folder;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: CustomTextInputField(
          controller: createNewList,
        )),
        IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              listsPageBloc.add(CreateListInFolderEvent.cancelCreate());
            }),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if(createNewList.text.isNotEmpty){
                listsPageBloc.add(
                    CreateListInFolderEvent.submit(
                        createClickupListInFolderParams:
                        CreateClickupListInFolderParams(
                            clickupAccessToken:
                            Globals.clickupAuthAccessToken,
                            clickupFolder:
                            folder,
                            listName:
                            createNewList.text),
                        clickupWorkspace:
                        Globals.selectedWorkspace!,
                        clickupSpace: Globals.selectedSpace!
                    ));
              }
            })
      ],
    );
  }
}

class _CreateListInSpace extends StatelessWidget {
  _CreateListInSpace({
    required this.listsPageBloc,
  });

  final TextEditingController createNewList = TextEditingController();
  final ListsPageBloc listsPageBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: CustomTextInputField(
          controller: createNewList,
        )),
        IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              listsPageBloc.add(CreateListInFolderEvent.cancelCreate());
            }),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
                    if (createNewList
                        .text.isNotEmpty) {
                      listsPageBloc.add(CreateFolderlessListEvent.submit(
                          createFolderlessListClickupParams: CreateFolderlessListClickupParams(
                              clickupAccessToken:
                                  Globals
                                      .clickupAuthAccessToken,
                              listName:
                                  createNewList
                                      .text,
                              clickupSpace:
                                  Globals
                                      .selectedSpace!),
                          clickupWorkspace:
                              Globals
                                  .selectedWorkspace!,
                          clickupSpace: Globals
                              .selectedSpace!));
                    }
                  })
      ],
    );
  }
}

class _CreateFolderInSpace extends StatelessWidget {
  _CreateFolderInSpace({
    required this.listsPageBloc,
  });

  final TextEditingController controller = TextEditingController();
  final ListsPageBloc listsPageBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: CustomTextInputField(
          controller: controller,
        )),
        IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              listsPageBloc.add(CreateClickupFolderInSpaceEvent.cancelCreate());
            }),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (controller
                  .text.isNotEmpty) {
                listsPageBloc.add(CreateClickupFolderInSpaceEvent.submit(
                    createClickupFolderInSpaceParams: CreateClickupFolderInSpaceParams(
                        clickupAccessToken:
                        Globals
                            .clickupAuthAccessToken,
                        folderName:
                        controller
                            .text,
                        clickupSpace:
                        Globals
                            .selectedSpace!),
                    clickupWorkspace:
                    Globals
                        .selectedWorkspace!,
                    clickupSpace: Globals
                        .selectedSpace!));
              }
            })
      ],
    );
  }
}
