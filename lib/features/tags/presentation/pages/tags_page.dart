import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tags_in_space_use_case.dart';

import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/localization/localization.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../bloc/tags_page_bloc.dart';
import 'tag_page.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  static const routeName = "/Tags";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<TagsPageBloc>(),
      child: BlocBuilder<StartupBloc, StartupState>(
          builder: (context, startupState) {
        return BlocConsumer<TagsPageBloc, TagsPageState>(
          listener: (context, state) {
            final bloc = BlocProvider.of<TagsPageBloc>(context);
            if (state.tagsPageStatus == TagsPageStatus.navigateTag &&
                state.navigateTag != null) {
              context.push(
                  Uri(path: TagPage.routeName, queryParameters: {
                    TagPage.queryParametersList.first:
                        state.navigateTag?.name ?? ""
                  }).toString(),
                  extra: bloc);
            } else if (state.tagsPageStatus == TagsPageStatus.deleteTagTry) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return CustomAlertDialog(
                      loading: false,
                      actions: [
                        CustomButton(
                            child: Text(appLocalization.translate("delete")),
                            onPressed: () {
                              bloc.add(DeleteClickupTagEvent.submit(
                                  params: DeleteClickupTagParams(
                                      space: Globals.selectedSpace!,
                                      tag: state.toDeleteTag!,
                                      clickupAccessToken:
                                          Globals.clickupAuthAccessToken)));
                              Navigator.pop(context);
                            }),
                        CustomButton(
                            child: Text(appLocalization.translate("cancel")),
                            onPressed: () {
                              bloc.add(DeleteClickupTagEvent.cancelDelete());
                              Navigator.pop(context);
                            }),
                      ],
                      content: Text(
                          "${appLocalization.translate("areYouSureDelete")} ${state.toDeleteTag?.name}?"),
                    );
                  });
            }
          },
          builder: (context, state) {
            final tagsPageBloc = BlocProvider.of<TagsPageBloc>(context);
            final startupBloc = BlocProvider.of<StartupBloc>(context);
            return ResponsiveScaffold(
                responsiveScaffoldLoading: ResponsiveScaffoldLoading(
                    responsiveScaffoldLoadingEnum:
                        ResponsiveScaffoldLoadingEnum.contentLoading,
                    isLoading: state.isLoading || startupState.isLoading),
                responsiveBody: ResponsiveTParams(
                    mobile: BlocConsumer<TagsPageBloc, TagsPageState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.isInit && Globals.isSpaceAppWide) {
                      tagsPageBloc.add(GetClickupTagsInSpaceEvent(
                          GetClickupTagsInSpaceParams(
                              clickupAccessToken:
                                  Globals.clickupAuthAccessToken,
                              clickupSpace: Globals.selectedSpace!)));
                    }
                    return SingleChildScrollView(
                        child: Column(
                            children: <Widget>[
                                  if (Globals.isSpaceAppWide == false &&
                                      Globals.clickupSpaces?.isNotEmpty == true)
                                    DropdownButton<ClickupSpace?>(
                                      value: Globals.selectedSpace,
                                      onChanged: (selected) {
                                        if (selected != null &&
                                            state.isLoading == false) {
                                          startupBloc.add(SelectClickupSpace(
                                              clickupSpace: selected,
                                              clickupAccessToken: Globals
                                                  .clickupAuthAccessToken));
                                          tagsPageBloc.add(
                                              GetClickupTagsInSpaceEvent(
                                                  GetClickupTagsInSpaceParams(
                                                      clickupAccessToken: Globals
                                                          .clickupAuthAccessToken,
                                                      clickupSpace: selected)));
                                        }
                                      },
                                      items: Globals.clickupSpaces
                                              ?.map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e.name ?? ""),
                                                  ))
                                              .toList() ??
                                          [],
                                      hint: Text(
                                          appLocalization.translate("spaces")),
                                    ),
                                ] +
                                (state.getTagsInSpaceResult ?? [])
                                    .map<Widget>((tag) => ListTile(
                                            onTap: (){
                                              tagsPageBloc.add(NavigateToTagPageEvent(tag));
                                            },
                                            title: Row(
                                          children: [
                                            const Icon(Icons.tag),
                                            Text(tag.name ?? ""),
                                            const Spacer(),
                                            PopupMenuButton(
                                                icon: const Icon(
                                                    Icons.more_horiz),
                                                itemBuilder: (ctx) => [
                                                      PopupMenuItem(
                                                          onTap: () {
                                                            tagsPageBloc.add(DeleteClickupTagEvent.tryDelete(
                                                                DeleteClickupTagParams(
                                                                    space: Globals
                                                                        .selectedSpace!,
                                                                    tag: tag,
                                                                    clickupAccessToken:
                                                                        Globals
                                                                            .clickupAuthAccessToken)));
                                                          },
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                  Icons.delete),
                                                              Text(appLocalization
                                                                  .translate(
                                                                      "delete")),
                                                            ],
                                                          ))
                                                    ])
                                          ],
                                        )))
                                    .toList()));
                  },
                )),
                context: context);
          },
        );
      }),
    );
  }
}

