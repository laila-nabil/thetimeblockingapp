import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thetimeblockingapp/common/widgets/custom_pop_up_menu.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/presentation/widgets/tag_component.dart';

import '../../../../common/widgets/custom_alert_dialog.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_input_field.dart';
import '../../../../common/widgets/responsive/responsive.dart';
import '../../../../common/widgets/responsive/responsive_scaffold.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/localization/localization.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_design.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../tasks/data/models/clickup_task_model.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../../../tasks/domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_tag_use_case.dart';
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
                        CustomButton.noIcon(
                            label: appLocalization.translate("delete"),
                            onPressed: () {
                              bloc.add(DeleteClickupTagEvent.submit(
                                  params: DeleteClickupTagParams(
                                      space: Globals.selectedSpace!,
                                      tag: state.toDeleteTag!,
                                      clickupAccessToken:
                                          Globals.clickupAuthAccessToken)));
                              Navigator.pop(context);
                            },type: CustomButtonType.destructiveFilledLabel),
                        CustomButton.noIcon(
                            label: appLocalization.translate("cancel"),
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
                    small: BlocConsumer<TagsPageBloc, TagsPageState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.isInit && Globals.isSpaceAppWide) {
                      tagsPageBloc.add(GetClickupTagsInSpaceEvent(
                          GetClickupTagsInSpaceParams(
                              clickupAccessToken:
                                  Globals.clickupAuthAccessToken,
                              clickupSpace: Globals.selectedSpace!)));
                    }
                    return Padding(
                      padding: EdgeInsets.all(AppSpacing.medium16.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppSpacing.medium16.value),
                            margin: EdgeInsets.only(
                                bottom: AppSpacing.medium16.value),
                            child: Text(
                              appLocalization.translate("Tags"),
                              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                                  color: AppColors.grey(context.isDarkMode).shade900,
                                  appFontWeight: AppFontWeight.medium,
                                  appFontSize: AppFontSize.heading4)),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: (state.getTagsInSpaceResult ?? [])
                                            .map<Widget>((tag) => TagComponent(
                                                  updateTagInline:
                                                      state.updateTagTry(tag)
                                                          ? SizedBox(
                                                              width: 300,
                                                              child:
                                                                  _CreateEditField(
                                                                      text:
                                                                          tag.name,
                                                                      onAdd:
                                                                          (text) {
                                                                        printDebug(
                                                                            "text now $text");
                                                                        tagsPageBloc.add(
                                                                            UpdateClickupTagEvent
                                                                                .submit(
                                                                          insideTagPage:
                                                                              false,
                                                                          params: UpdateClickupTagParams(
                                                                              clickupAccessToken: Globals
                                                                                  .clickupAuthAccessToken,
                                                                              newTag: tag
                                                                                  .copyWith(name: text)
                                                                                  .getModel,
                                                                              originalTagName: tag.name ?? "",
                                                                              space: Globals.selectedSpace!),
                                                                        ));
                                                                      },
                                                                      onCancel: () {
                                                                        tagsPageBloc.add(UpdateClickupTagEvent.cancel(
                                                                            insideTagPage:
                                                                                false));
                                                                      }),
                                                            )
                                                          : null,
                                                  actions: [
                                                    CustomPopupItem(
                                                        title: appLocalization
                                                            .translate("edit"),
                                                        onTap: () {
                                                          tagsPageBloc.add(UpdateClickupTagEvent.tryUpdate(
                                                              insideTagPage: false,
                                                              params: UpdateClickupTagParams(
                                                                  space: Globals
                                                                      .selectedSpace!,
                                                                  newTag:
                                                                      tag.getModel,
                                                                  originalTagName:
                                                                      tag.name ??
                                                                          "",
                                                                  clickupAccessToken:
                                                                      Globals
                                                                          .clickupAuthAccessToken)));
                                                        }),
                                                    CustomPopupItem(
                                                        title: appLocalization
                                                            .translate("delete"),
                                                        onTap: () {
                                                          tagsPageBloc.add(DeleteClickupTagEvent.tryDelete(
                                                              DeleteClickupTagParams(
                                                                  space: Globals
                                                                      .selectedSpace!,
                                                                  tag: tag,
                                                                  clickupAccessToken:
                                                                      Globals
                                                                          .clickupAuthAccessToken)));
                                                        }),
                                                  ],
                                                  tag: tag,
                                                  onTap: () {
                                                    tagsPageBloc.add(
                                                        NavigateToTagPageEvent(
                                                            tag: tag,
                                                            insideTagPage: false));
                                                  },
                                                ))
                                            .toList() +
                                        [
                                          state.tryCreateTagInSpace == true
                                              ? _CreateEditField(onAdd: (text) {
                                                  tagsPageBloc.add(
                                                      CreateClickupTagInSpaceEvent
                                                          .submit(
                                                    params: CreateClickupTagInSpaceParams(
                                                        clickupAccessToken: Globals
                                                            .clickupAuthAccessToken,
                                                        newTag: ClickupTagModel(
                                                            name: text),
                                                        space:
                                                            Globals.selectedSpace!),
                                                  ));
                                                }, onCancel: () {
                                                  tagsPageBloc.add(
                                                      CreateClickupTagInSpaceEvent
                                                          .cancelCreate());
                                                })
                                              : CustomButton.noIcon(
                                                  label:
                                                      "+ ${appLocalization.translate("createNewTag")}",
                                                  onPressed: () {
                                                    tagsPageBloc.add(
                                                        CreateClickupTagInSpaceEvent
                                                            .tryCreate());
                                                  },
                                                  type: CustomButtonType
                                                      .greyTextLabel,
                                                )
                                        ])),
                          ),
                        ],
                      ),
                    );
                  },
                )),
                context: context, onRefresh: ()async {
              tagsPageBloc.add(GetClickupTagsInSpaceEvent(
                  GetClickupTagsInSpaceParams(
                      clickupAccessToken:
                      Globals.clickupAuthAccessToken,
                      clickupSpace: Globals.selectedSpace!)));
              startupBloc.add(SelectClickupWorkspaceAndGetSpacesTagsLists(
                  clickupWorkspace: Globals.selectedWorkspace!,
                  clickupAccessToken: Globals.clickupAuthAccessToken));
            },);
          },
        );
      }),
    );
  }
}

class _CreateEditField extends StatefulWidget {
  const _CreateEditField(
      {required this.onAdd, this.text, required this.onCancel});

  final String? text;
  final void Function(String text) onAdd;
  final void Function() onCancel;

  @override
  State<_CreateEditField> createState() => _CreateEditFieldState();
}

class _CreateEditFieldState extends State<_CreateEditField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextInputField(
          focusNode: FocusNode(),
          controller: controller,
        )),
        IconButton(icon: const Icon(Icons.cancel), onPressed: widget.onCancel),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                widget.onAdd(controller.text);
              }
            })
      ],
    );
  }
}
