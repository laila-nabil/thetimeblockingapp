import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/extensions.dart';

import '../../core/resources/app_icons.dart';

///TODO update UI to match Figma design

/// A [TextFormField] configured to accept and validate a date entered by a user.
///
/// When the field is saved or submitted, the text will be parsed into a
/// [DateTime] according to the ambient locale's compact date format. If the
/// input text doesn't parse into a date, the [errorFormatText] message will
/// be displayed under the field.
///
/// [firstDate], [lastDate], and [selectableDayPredicate] provide constraints on
/// what days are valid. If the input date isn't in the date range or doesn't pass
/// the given predicate, then the [errorInvalidText] message will be displayed
/// under the field.
///
/// See also:
///
///  * [showDatePicker], which shows a dialog that contains a Material Design
///    date picker which includes support for text entry of dates.
///
class CustomInputDatePickerFormField extends StatefulWidget {
  /// Creates a [TextFormField] configured to accept and validate a date.
  ///
  /// If the optional [initialDate] is provided, then it will be used to populate
  /// the text field. If the [fieldHintText] is provided, it will be shown.
  ///
  /// If [initialDate] is provided, it must not be before [firstDate] or after
  /// [lastDate]. If [selectableDayPredicate] is provided, it must return `true`
  /// for [initialDate].
  ///
  /// [firstDate] must be on or before [lastDate].
  ///
  /// [firstDate], [lastDate], and [autofocus] must be non-null.
  ///
  CustomInputDatePickerFormField({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateSubmitted,
    this.onDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.onTapEdit,
    this.onTapClear,
    this.autofocus = false,
  }) {
    assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
    );
    assert(
    initialDate == null || !initialDate!.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
    );
    assert(
    initialDate == null || !initialDate!.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
    );
    assert(
    selectableDayPredicate == null || initialDate == null || selectableDayPredicate!(initialDate!),
    'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.',
    );
  }

  /// If provided, it will be used as the default value of the field.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDate;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field. Will only be called if the input represents a valid
  /// [DateTime].
  final ValueChanged<DateTime>? onDateSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save]. Will only be called if the input represents
  /// a valid [DateTime].
  final ValueChanged<DateTime>? onDateSaved;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String? errorInvalidText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format
  /// string from DateTimeExtensions.
  final String? fieldHintText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String? fieldLabelText;

  /// The keyboard type of the [TextField].
  ///
  /// If this is null, it will default to [TextInputType.datetime]
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  final void Function()? onTapEdit;

  final void Function()? onTapClear;

  @override
  State<CustomInputDatePickerFormField> createState() => _CustomInputDatePickerFormFieldState();
}

class _CustomInputDatePickerFormFieldState extends State<CustomInputDatePickerFormField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  String? _inputText;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateValueForSelectedDate();
  }

  @override
  void didUpdateWidget(CustomInputDatePickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      // Can't update the form field in the middle of a build, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          _selectedDate = widget.initialDate;
          _updateValueForSelectedDate();
        });
      });
    }
  }

  void _updateValueForSelectedDate() {
    if (_selectedDate != null) {
      _inputText = DateTimeExtensions.customToString(_selectedDate);
      TextEditingValue textEditingValue = TextEditingValue(text: _inputText!);
      // Select the new text if we are auto focused and haven't selected the text before.
      if (widget.autofocus && !_autoSelected) {
        textEditingValue = textEditingValue.copyWith(selection: TextSelection(
          baseOffset: 0,
          extentOffset: _inputText!.length,
        ));
        _autoSelected = true;
      }
      _controller.value = textEditingValue;
    } else {
      _inputText = '';
      _controller.value = TextEditingValue(text: _inputText!);
    }
  }

  DateTime? _parseDate(String? text) {
    return DateTime.tryParse(text??"");
  }

  bool _isValidAcceptableDate(DateTime? date) {
    return
      date != null &&
          !date.isBefore(widget.firstDate) &&
          !date.isAfter(widget.lastDate) &&
          (widget.selectableDayPredicate == null || widget.selectableDayPredicate!(date));
  }

  String? _validateDate(String? text) {
    final DateTime? date = _parseDate(text);
    if (date == null) {
      return widget.errorFormatText ?? MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      return widget.errorInvalidText ?? MaterialLocalizations.of(context).dateOutOfRangeLabel;
    }
    return null;
  }

  void _updateDate(String? text, ValueChanged<DateTime>? callback) {
    final DateTime? date = _parseDate(text);
    if (_isValidAcceptableDate(date)) {
      _selectedDate = date;
      _inputText = text;
      callback?.call(_selectedDate!);
    }
  }

  void _handleSaved(String? text) {
    _updateDate(text, widget.onDateSaved);
  }

  void _handleSubmitted(String text) {
    _updateDate(text, widget.onDateSubmitted);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool useMaterial3 = theme.useMaterial3;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final InputDecorationTheme inputTheme = theme.inputDecorationTheme;
    final InputBorder inputBorder = inputTheme.border
        ?? (useMaterial3 ? const OutlineInputBorder() : const UnderlineInputBorder());

    return TextFormField(
      decoration: InputDecoration(
        border: inputBorder,
        filled: inputTheme.filled,
        isCollapsed: false,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.onTapEdit != null)
              IconButton(
                  onPressed: () => widget.onTapEdit!(),
                  icon: const Icon(Icons.edit)),
            if (widget.onTapClear != null)
              IconButton(
                  onPressed: () => widget.onTapClear!(),
                  icon: const Icon(AppIcons.bin))
          ],
        ),
        hintText: widget.fieldHintText ?? localizations.dateHelpText,
        labelText: widget.fieldLabelText ?? localizations.dateInputLabel,
      ),
      validator: _validateDate,
      keyboardType: widget.keyboardType ?? TextInputType.datetime,
      onSaved: _handleSaved,
      onFieldSubmitted: _handleSubmitted,
      autofocus: widget.autofocus,
      controller: _controller,
    );
  }
}
