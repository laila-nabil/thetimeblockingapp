import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thetimeblockingapp/core/resources/app_colors.dart';
import 'package:thetimeblockingapp/core/resources/app_design.dart';
import 'package:thetimeblockingapp/core/resources/app_icons.dart';
import 'package:thetimeblockingapp/core/resources/app_theme.dart';
import 'package:thetimeblockingapp/core/resources/text_styles.dart';

enum CustomTextInputFieldSize { small, large }

enum CustomTextInputFieldStyle { box, line }

class CustomTextInputField extends StatefulWidget {
  const CustomTextInputField({
    super.key,
    this.controller,
    this.size = CustomTextInputFieldSize.small,
    this.buttonStyle = CustomTextInputFieldStyle.box,
    required this.focusNode,
    this.undoController,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.successText,
    this.prefixIcon,
    this.prefixImage,
    this.isPassword = false,
  });

  final CustomTextInputFieldStyle buttonStyle;
  final CustomTextInputFieldSize size;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? successText;

  final TextEditingController? controller;
  final FocusNode focusNode;
  final UndoHistoryController? undoController;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final bool? showCursor;
  final bool autofocus;
  final String obscuringCharacter;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final MouseCursor? mouseCursor;
  final Widget? Function(BuildContext,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? buildCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final bool canRequestFocus;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final IconData? prefixIcon;
  final String? prefixImage;
  final bool isPassword;

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  bool isChanging = false;
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.isPassword;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isSuccess = widget.successText?.isNotEmpty == true;
    bool isError = widget.errorText?.isNotEmpty == true;
    double iconSize = 20;
    bool isBox = widget.buttonStyle == CustomTextInputFieldStyle.box;
    bool isSmall = widget.size == CustomTextInputFieldSize.small;
    double textFieldHeight = isSmall ? 36 : 56;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.x2Small4.value),
            child: Text(
              widget.labelText ?? "",
              style: AppTextStyle.getTextStyle(AppTextStyleParams(
                  appFontSize: AppFontSize.paragraphSmall,
                  color: AppColors.grey(context.isDarkMode).shade900,
                  appFontWeight: AppFontWeight.medium)),
            ),
          ),
        Stack(
          children: [
            Container(
              height: isBox ? (textFieldHeight + (isSmall ? 2 : 0)) : 1,
              margin: isBox
                  ? EdgeInsets.only(
                      top: isSmall ? 1 : 0,
                    )
                  : EdgeInsets.only(
                      top: (textFieldHeight) - 0.1,
                      right: 8,
                      left: 8,
                    ),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      isBox ? BorderRadius.circular(6) : BorderRadius.zero,
                ),
                shadows:
                    (widget.buttonStyle == CustomTextInputFieldStyle.line ||
                            (widget.maxLines != null && widget.maxLines! > 1))
                        ? []
                    : [
                        if (isChanging)
                          BoxShadow(
                            color: AppColors.warning(context.isDarkMode).shade50,
                            blurRadius: 0,
                            offset: const Offset(0, 0),
                            spreadRadius: 4,
                          ),
                        if (isError)
                          BoxShadow(
                            color: AppColors.error(context.isDarkMode).shade50,
                            blurRadius: 0,
                            offset: const Offset(0, 0),
                            spreadRadius: 4,
                          ),
                        if (isSuccess)
                          BoxShadow(
                            color: AppColors.success(context.isDarkMode).shade50,
                            blurRadius: 0,
                            offset: const Offset(0, 0),
                            spreadRadius: 4,
                          ),
                      ],
              ),
            ),
            TextField(
                focusNode: widget.focusNode,
                onTap: widget.onTap,
                controller: widget.controller,
                autocorrect: widget.autocorrect,
                autofillHints: widget.autofillHints,
                autofocus: widget.autofocus,
                buildCounter: widget.buildCounter,
                canRequestFocus: widget.canRequestFocus,
                clipBehavior: widget.clipBehavior,
                contentInsertionConfiguration:
                    widget.contentInsertionConfiguration,
                contextMenuBuilder: widget.contextMenuBuilder,
                cursorColor: widget.cursorColor,
                cursorHeight: widget.cursorHeight,
                cursorOpacityAnimates: widget.cursorOpacityAnimates,
                cursorRadius: widget.cursorRadius,
                cursorWidth: widget.cursorWidth,
                decoration: InputDecoration(
                  prefixIcon:
                      (widget.prefixIcon == null || widget.prefixImage != null)
                          ? null
                          : Icon(
                              widget.prefixIcon,
                              size: iconSize,
                            ),
                  prefix:
                      (widget.prefixImage == null || widget.prefixIcon != null)
                          ? null
                          : Image.asset(
                              widget.prefixImage ?? "",
                              width: iconSize,
                              height: iconSize,
                            ),
                  suffixIcon: (widget.isPassword && obscureText)
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            Icons.visibility,
                            color: AppColors.grey(context.isDarkMode).shade500,
                          ),
                        )
                      : (widget.isPassword && obscureText == false)
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                Icons.visibility_off,
                                color:
                                    AppColors.grey(context.isDarkMode).shade500,
                              ),
                            )
                          : isSuccess
                              ? Icon(
                                  AppIcons.checkcircle,
                                  color: AppColors.success(context.isDarkMode)
                                      .shade500,
                                )
                              : isError
                                  ? Icon(
                                      AppIcons.multiplycircle,
                                      color: AppColors.error(context.isDarkMode)
                                          .shade500,
                                    )
                                  : null,
                  enabled: widget.enabled ?? true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.size == CustomTextInputFieldSize.small
                          ? AppSpacing.small12.value
                          : AppSpacing.medium16.value,
                      vertical: widget.size == CustomTextInputFieldSize.small
                          ? AppSpacing.xSmall8.value + 4
                          : 18 + 4),
                  floatingLabelStyle: AppTextStyle.getTextStyle(
                      AppTextStyleParams(
                          appFontSize: AppFontSize.paragraphSmall,
                          color: AppColors.grey(context.isDarkMode).shade900,
                          appFontWeight: AppFontWeight.medium)),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  hintText: widget.hintText,
                  hintStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphSmall,
                      color: AppColors.grey(context.isDarkMode).shade400,
                      appFontWeight: AppFontWeight.regular)),
                  helperText: widget.helperText,
                  helperStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphSmall,
                      color: AppColors.grey(context.isDarkMode).shade500,
                      appFontWeight: AppFontWeight.regular)),
                  disabledBorder: isBox
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.grey(context.isDarkMode).shade300, width: 1))
                      : UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.grey(context.isDarkMode).shade300, width: 0)),
                  enabledBorder: isBox
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.grey(context.isDarkMode).shade300, width: 1))
                      : UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.grey(context.isDarkMode).shade300, width: 1)),
                  focusedBorder: isBox
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.primary(context.isDarkMode).shade100, width: 1),
                        )
                      : UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: (widget.buttonStyle == CustomTextInputFieldStyle.line ||
                                  (widget.maxLines != null && widget.maxLines! > 1))
                                  ? (isChanging
                                      ? AppColors.warning(context.isDarkMode).shade300
                                      : isError
                                          ? AppColors.error(context.isDarkMode).shade300
                                          : isSuccess
                                              ? AppColors.success(context.isDarkMode).shade300
                                              : AppColors.primary(context.isDarkMode).shade100)
                                  : AppColors.primary(context.isDarkMode).shade100,
                              width: 1),
                        ),
                  border: isBox
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.grey(context.isDarkMode).shade300, width: 1))
                      : UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: AppColors.grey(context.isDarkMode).shade300, width: 1)),
                  errorBorder: isBox
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: isSuccess
                                  ? AppColors.success(context.isDarkMode).shade200
                                  : AppColors.error(context.isDarkMode).shade200,
                              width: 1))
                      : UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: isSuccess
                                  ? AppColors.success(context.isDarkMode).shade200
                                  : AppColors.error(context.isDarkMode).shade200,
                              width: 1)),
                  errorStyle: AppTextStyle.getTextStyle(AppTextStyleParams(
                      appFontSize: AppFontSize.paragraphSmall,
                      color: isSuccess
                          ? AppColors.success(context.isDarkMode).shade600
                          : AppColors.error(context.isDarkMode).shade500,
                      appFontWeight: AppFontWeight.regular)),
                  errorText: widget.successText ?? widget.errorText,
                  fillColor: widget.enabled == false
                      ? AppColors.grey(context.isDarkMode).shade100
                      : widget.buttonStyle == CustomTextInputFieldStyle.line
                          ? Colors.transparent
                          : AppColors.white(context.isDarkMode),
                  filled: true,
                ),
                dragStartBehavior: widget.dragStartBehavior,
                enabled: widget.enabled,
                enableIMEPersonalizedLearning:
                    widget.enableIMEPersonalizedLearning,
                enableInteractiveSelection: widget.enableInteractiveSelection,
                enableSuggestions: widget.enableSuggestions,
                expands: widget.expands,
                inputFormatters: widget.inputFormatters,
                key: widget.key,
                keyboardAppearance: widget.keyboardAppearance,
                keyboardType: widget.keyboardType,
                magnifierConfiguration: widget.magnifierConfiguration,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                maxLengthEnforcement: widget.maxLengthEnforcement,
                obscureText: obscureText,
                obscuringCharacter: widget.obscuringCharacter,
                onAppPrivateCommand: widget.onAppPrivateCommand,
                onChanged: (input) {
                  if (isChanging == false && input.isNotEmpty) {
                    setState(() {
                      isChanging = true;
                    });
                  }
                  if (isChanging == true && input.isEmpty) {
                    setState(() {
                      isChanging = false;
                    });
                  }
                  widget.onChanged != null ? widget.onChanged!(input) : () {};
                },
                onEditingComplete: widget.onEditingComplete,
                onSubmitted: widget.onSubmitted,
                onTapOutside: widget.onTapOutside,
                readOnly: widget.readOnly,
                restorationId: widget.restorationId,
                scribbleEnabled: widget.scribbleEnabled,
                scrollController: widget.scrollController,
                scrollPadding: widget.scrollPadding,
                scrollPhysics: widget.scrollPhysics,
                selectionControls: widget.selectionControls,
                selectionHeightStyle: widget.selectionHeightStyle,
                selectionWidthStyle: widget.selectionWidthStyle,
                showCursor: widget.showCursor,
                smartDashesType: widget.smartDashesType,
                smartQuotesType: widget.smartQuotesType,
                spellCheckConfiguration: widget.spellCheckConfiguration,
                strutStyle: widget.strutStyle,
                style: widget.style,
                textAlign: widget.textAlign,
                textAlignVertical: widget.textAlignVertical,
                textCapitalization: widget.textCapitalization,
                textDirection: widget.textDirection,
                textInputAction: widget.textInputAction,
                undoController: widget.undoController,
                minLines: widget.minLines,
                mouseCursor: widget.mouseCursor),
          ],
        )
      ],
    );
  }
}