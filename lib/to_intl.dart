import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

/// A custom set of date patterns for the `to` locale.
///
/// These are not accurate and are just a clone of the date patterns for the
/// `no` locale to demonstrate how one would write and use custom date patterns.
// #docregion Date
const toLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
// #enddocregion Date
  'LLLL': 'LLLL',
  'M': 'L.',
  'Md': 'd.M.',
  'MEd': 'EEE d.M.',
  'MMM': 'LLL',
  'MMMd': 'd. MMM',
  'MMMEd': 'EEE d. MMM',
  'MMMM': 'LLLL',
  'MMMMd': 'd. MMMM',
  'MMMMEEEEd': 'EEEE d. MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'M.y',
  'yMd': 'd.M.y',
  'yMEd': 'EEE d.MM.y',
  'yMMM': 'MMM y',
  'yMMMd': 'd. MMM y',
  'yMMMEd': 'EEE d. MMM y',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd. MMMM y',
  'yMMMMEEEEd': 'EEEE d. MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

/// A custom set of date symbols for the `to` locale.
///
/// These are not accurate and are just a clone of the date symbols for the
/// `no` locale to demonstrate how one would write and use custom date symbols.
// #docregion Date2
const toDateSymbols = {
  'NAME': 'to',
  'ERAS': <dynamic>[
    'f.Kr.',
    'e.Kr.',
  ],
// #enddocregion Date2
  'ERANAMES': <dynamic>[
    'før Kristus',
    'etter Kristus',
  ],
  'NARROWMONTHS': <dynamic>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ],
  'STANDALONENARROWMONTHS': <dynamic>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ],
  'MONTHS': <dynamic>[
    'januar',
    'februar',
    'mars',
    'april',
    'mai',
    'juni',
    'juli',
    'august',
    'september',
    'oktober',
    'november',
    'desember',
  ],
  'STANDALONEMONTHS': <dynamic>[
    'januar',
    'februar',
    'mars',
    'april',
    'mai',
    'juni',
    'juli',
    'august',
    'september',
    'oktober',
    'november',
    'desember',
  ],
  'SHORTMONTHS': <dynamic>[
    'jan.',
    'feb.',
    'mar.',
    'apr.',
    'mai',
    'jun.',
    'jul.',
    'aug.',
    'sep.',
    'okt.',
    'nov.',
    'des.',
  ],
  'STANDALONESHORTMONTHS': <dynamic>[
    'jan',
    'feb',
    'mar',
    'apr',
    'mai',
    'jun',
    'jul',
    'aug',
    'sep',
    'okt',
    'nov',
    'des',
  ],
  'WEEKDAYS': <dynamic>[
    'søndag',
    'mandag',
    'tirsdag',
    'onsdag',
    'torsdag',
    'fredag',
    'lørdag',
  ],
  'STANDALONEWEEKDAYS': <dynamic>[
    'søndag',
    'mandag',
    'tirsdag',
    'onsdag',
    'torsdag',
    'fredag',
    'lørdag',
  ],
  'SHORTWEEKDAYS': <dynamic>[
    'søn.',
    'man.',
    'tir.',
    'ons.',
    'tor.',
    'fre.',
    'lør.',
  ],
  'STANDALONESHORTWEEKDAYS': <dynamic>[
    'søn.',
    'man.',
    'tir.',
    'ons.',
    'tor.',
    'fre.',
    'lør.',
  ],
  'NARROWWEEKDAYS': <dynamic>[
    'S',
    'M',
    'T',
    'O',
    'T',
    'F',
    'L',
  ],
  'STANDALONENARROWWEEKDAYS': <dynamic>[
    'S',
    'M',
    'T',
    'O',
    'T',
    'F',
    'L',
  ],
  'SHORTQUARTERS': <dynamic>[
    'K1',
    'K2',
    'K3',
    'K4',
  ],
  'QUARTERS': <dynamic>[
    '1. kvartal',
    '2. kvartal',
    '3. kvartal',
    '4. kvartal',
  ],
  'AMPMS': <dynamic>[
    'a.m.',
    'p.m.',
  ],
  'DATEFORMATS': <dynamic>[
    'EEEE d. MMMM y',
    'd. MMMM y',
    'd. MMM y',
    'dd.MM.y',
  ],
  'TIMEFORMATS': <dynamic>[
    'HH:mm:ss zzzz',
    'HH:mm:ss z',
    'HH:mm:ss',
    'HH:mm',
  ],
  'AVAILABLEFORMATS': null,
  'FIRSTDAYOFWEEK': 0,
  'WEEKENDRANGE': <dynamic>[
    5,
    6,
  ],
  'FIRSTWEEKCUTOFFDAY': 3,
  'DATETIMEFORMATS': <dynamic>[
    '{1} {0}',
    '{1} \'kl\'. {0}',
    '{1}, {0}',
    '{1}, {0}',
  ],
};

// #docregion Delegate
class _ToMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _ToMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'to';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());

    // The locale (in this case `to`) needs to be initialized into the custom
    // date symbols and patterns setup that Flutter uses.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: toLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(toDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      ToMaterialLocalizations(
        localeName: localeName,
        // The `intl` library's NumberFormat class is generated from CLDR data
        // (see https://github.com/dart-lang/i18n/blob/main/pkgs/intl/lib/number_symbols_data.dart).
        // Unfortunately, there is no way to use a locale that isn't defined in
        // this map and the only way to work around this is to use a listed
        // locale's NumberFormat symbols. So, here we use the number formats
        // for 'en_US' instead.
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        // DateFormat here will use the symbols and patterns provided in the
        // `date_symbol_data_custom.initializeDateFormattingCustom` call above.
        // However, an alternative is to simply use a supported locale's
        // DateFormat symbols, similar to NumberFormat above.
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d', localeName),
      ),
    );
  }

  @override
  bool shouldReload(_ToMaterialLocalizationsDelegate old) => false;
}
// #enddocregion Delegate

/// A custom set of localizations for the 'to' locale. In this example, only
/// the value for openAppDrawerTooltip was modified to use a custom message as
/// an example. Everything else uses the American English (en_US) messages
/// and formatting.
class ToMaterialLocalizations extends GlobalMaterialLocalizations {
  const ToMaterialLocalizations({
    super.localeName = 'to',
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

// #docregion Getters
  @override
  String get moreButtonTooltip => r'More';

  @override
  String get aboutListTileTitleRaw => r'About $applicationName';

  @override
  String get alertDialogLabel => r'Alert';

// #enddocregion Getters

  @override
  String get anteMeridiemAbbreviation => r'AM';

  @override
  String get backButtonTooltip => r'Back';

  @override
  String get cancelButtonLabel => r'CANCEL';

  @override
  String get closeButtonLabel => r'CLOSE';

  @override
  String get closeButtonTooltip => r'Close';

  @override
  String get collapsedIconTapHint => r'Expand';

  @override
  String get continueButtonLabel => r'CONTINUE';

  @override
  String get copyButtonLabel => r'COPY';

  @override
  String get cutButtonLabel => r'CUT';

  @override
  String get deleteButtonTooltip => r'Delete';

  @override
  String get dialogLabel => r'Dialog';

  @override
  String get drawerLabel => r'Navigation menu';

  @override
  String get expandedIconTapHint => r'Collapse';

  @override
  String get firstPageTooltip => r'First page';

  @override
  String get hideAccountsLabel => r'Hide accounts';

  @override
  String get lastPageTooltip => r'Last page';

  @override
  String get licensesPageTitle => r'Licenses';

  @override
  String get modalBarrierDismissLabel => r'Dismiss';

  @override
  String get nextMonthTooltip => r'Next month';

  @override
  String get nextPageTooltip => r'Next page';

  @override
  String get okButtonLabel => r'OK';

  @override
  // A custom drawer tooltip message.
  String get openAppDrawerTooltip => r'Custom Navigation Menu Tooltip';

// #docregion Raw
  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow of $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow of about $rowCount';
// #enddocregion Raw

  @override
  String get pasteButtonLabel => r'PASTE';

  @override
  String get popupMenuLabel => r'Popup menu';

  @override
  String get menuBarMenuLabel => r'Menu Bar Label';

  @override
  String get postMeridiemAbbreviation => r'PM';

  @override
  String get previousMonthTooltip => r'Previous month';

  @override
  String get previousPageTooltip => r'Previous page';

  @override
  String get refreshIndicatorSemanticLabel => r'Refresh';

  @override
  String? get remainingTextFieldCharacterCountFew => null;

  @override
  String? get remainingTextFieldCharacterCountMany => null;

  @override
  String get remainingTextFieldCharacterCountOne => r'1 character remaining';

  @override
  String get remainingTextFieldCharacterCountOther =>
      r'$remainingCount characters remaining';

  @override
  String? get remainingTextFieldCharacterCountTwo => null;

  @override
  String get remainingTextFieldCharacterCountZero => r'No characters remaining';

  @override
  String get reorderItemDown => r'Move down';

  @override
  String get reorderItemLeft => r'Move left';

  @override
  String get reorderItemRight => r'Move right';

  @override
  String get reorderItemToEnd => r'Move to the end';

  @override
  String get reorderItemToStart => r'Move to the start';

  @override
  String get reorderItemUp => r'Move up';

  @override
  String get rowsPerPageTitle => r'Rows per page:';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => r'Search';

  @override
  String get selectAllButtonLabel => r'SELECT ALL';

  @override
  String? get selectedRowCountTitleFew => null;

  @override
  String? get selectedRowCountTitleMany => null;

  @override
  String get selectedRowCountTitleOne => r'1 item selected';

  @override
  String get selectedRowCountTitleOther => r'$selectedRowCount items selected';

  @override
  String? get selectedRowCountTitleTwo => null;

  @override
  String get selectedRowCountTitleZero => r'No items selected';

  @override
  String get showAccountsLabel => r'Show accounts';

  @override
  String get showMenuTooltip => r'Show menu';

  @override
  String get signedInLabel => r'Signed in';

  @override
  String get tabLabelRaw => r'Tab $tabIndex of $tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerHourModeAnnouncement => r'Select hours';

  @override
  String get timePickerMinuteModeAnnouncement => r'Select minutes';

  @override
  String get viewLicensesButtonLabel => r'VIEW LICENSES';

  @override
  List<String> get narrowWeekdays =>
      const <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  int get firstDayOfWeekIndex => 0;

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _ToMaterialLocalizationsDelegate();

  @override
  String get calendarModeButtonLabel => r'Switch to calendar';

  @override
  String get dateHelpText => r'mm/dd/yyyy';

  @override
  String get dateInputLabel => r'Enter Date';

  @override
  String get dateOutOfRangeLabel => r'Out of range.';

  @override
  String get datePickerHelpText => r'SELECT DATE';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'End date $fullDate';

  @override
  String get dateRangeEndLabel => r'End Date';

  @override
  String get dateRangePickerHelpText => 'SELECT RANGE';

  @override
  String get dateRangeStartDateSemanticLabelRaw => 'Start date \$fullDate';

  @override
  String get dateRangeStartLabel => 'Start Date';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => 'Switch to dial picker mode';

  @override
  String get inputDateModeButtonLabel => 'Switch to input';

  @override
  String get inputTimeModeButtonLabel => 'Switch to text input mode';

  @override
  String get invalidDateFormatLabel => 'Invalid format.';

  @override
  String get invalidDateRangeLabel => 'Invalid range.';

  @override
  String get invalidTimeLabel => 'Enter a valid time';

  @override
  String get licensesPackageDetailTextOther => '\$licenseCount licenses';

  @override
  String get saveButtonLabel => 'SAVE';

  @override
  String get selectYearSemanticsLabel => 'Select year';

  @override
  String get timePickerDialHelpText => 'SELECT TIME';

  @override
  String get timePickerHourLabel => 'Hour';

  @override
  String get timePickerInputHelpText => 'ENTER TIME';

  @override
  String get timePickerMinuteLabel => 'Minute';

  @override
  String get unspecifiedDate => 'Date';

  @override
  String get unspecifiedDateRange => 'Date Range';

  @override
  // TODO: implement bottomSheetLabel
  String get bottomSheetLabel => 'bottomSheetLabel';

  @override
  // TODO: implement collapsedHint
  String get collapsedHint => 'collapsedHint';

  @override
  // TODO: implement currentDateLabel
  String get currentDateLabel => 'currentDateLabel';

  @override
  // TODO: implement expandedHint
  String get expandedHint => 'expandedHint';

  @override
  // TODO: implement expansionTileCollapsedHint
  String get expansionTileCollapsedHint => 'expansionTileCollapsedHint';

  @override
  // TODO: implement expansionTileCollapsedTapHint
  String get expansionTileCollapsedTapHint => 'expansionTileCollapsedTapHint';

  @override
  // TODO: implement expansionTileExpandedHint
  String get expansionTileExpandedHint => 'expansionTileExpandedHint';

  @override
  // TODO: implement expansionTileExpandedTapHint
  String get expansionTileExpandedTapHint => 'expansionTileExpandedTapHint';

  @override
  // TODO: implement keyboardKeyAlt
  String get keyboardKeyAlt => 'keyboardKeyAlt';

  @override
  // TODO: implement keyboardKeyAltGraph
  String get keyboardKeyAltGraph => 'keyboardKeyAltGraph';

  @override
  // TODO: implement keyboardKeyBackspace
  String get keyboardKeyBackspace => 'keyboardKeyBackspace';

  @override
  // TODO: implement keyboardKeyCapsLock
  String get keyboardKeyCapsLock => 'keyboardKeyCapsLock';

  @override
  // TODO: implement keyboardKeyChannelDown
  String get keyboardKeyChannelDown => 'keyboardKeyChannelDown';

  @override
  // TODO: implement keyboardKeyChannelUp
  String get keyboardKeyChannelUp => 'keyboardKeyChannelUp';

  @override
  // TODO: implement keyboardKeyControl
  String get keyboardKeyControl => 'keyboardKeyControl';

  @override
  // TODO: implement keyboardKeyDelete
  String get keyboardKeyDelete => 'keyboardKeyDelete';

  @override
  // TODO: implement keyboardKeyEject
  String get keyboardKeyEject => 'keyboardKeyEject';

  @override
  // TODO: implement keyboardKeyEnd
  String get keyboardKeyEnd => 'keyboardKeyEnd';

  @override
  // TODO: implement keyboardKeyEscape
  String get keyboardKeyEscape => 'keyboardKeyEscap';

  @override
  // TODO: implement keyboardKeyFn
  String get keyboardKeyFn => 'keyboardKeyFn';

  @override
  // TODO: implement keyboardKeyHome
  String get keyboardKeyHome => 'keyboardKeyHome';

  @override
  // TODO: implement keyboardKeyInsert
  String get keyboardKeyInsert => 'keyboardKeyInsert';

  @override
  // TODO: implement keyboardKeyMeta
  String get keyboardKeyMeta => 'keyboardKeyMeta';

  @override
  // TODO: implement keyboardKeyMetaMacOs
  String get keyboardKeyMetaMacOs => 'keyboardKeyMetaMacOs';

  @override
  // TODO: implement keyboardKeyMetaWindows
  String get keyboardKeyMetaWindows => 'keyboardKeyMetaWindows';

  @override
  // TODO: implement keyboardKeyNumLock
  String get keyboardKeyNumLock => 'keyboardKeyNumLock';

  @override
  // TODO: implement keyboardKeyNumpad0
  String get keyboardKeyNumpad0 => 'keyboardKeyNumpad0';

  @override
  // TODO: implement keyboardKeyNumpad1
  String get keyboardKeyNumpad1 => 'keyboardKeyNumpad1';

  @override
  // TODO: implement keyboardKeyNumpad2
  String get keyboardKeyNumpad2 => 'keyboardKeyNumpad2';

  @override
  // TODO: implement keyboardKeyNumpad3
  String get keyboardKeyNumpad3 => 'keyboardKeyNumpad3';

  @override
  // TODO: implement keyboardKeyNumpad4
  String get keyboardKeyNumpad4 => 'keyboardKeyNumpad4';

  @override
  // TODO: implement keyboardKeyNumpad5
  String get keyboardKeyNumpad5 => 'keyboardKeyNumpad5';

  @override
  // TODO: implement keyboardKeyNumpad6
  String get keyboardKeyNumpad6 => 'keyboardKeyNumpad6';

  @override
  // TODO: implement keyboardKeyNumpad7
  String get keyboardKeyNumpad7 => 'keyboardKeyNumpad7';

  @override
  // TODO: implement keyboardKeyNumpad8
  String get keyboardKeyNumpad8 => 'keyboardKeyNumpad8';

  @override
  // TODO: implement keyboardKeyNumpad9
  String get keyboardKeyNumpad9 => 'keyboardKeyNumpad9';

  @override
  // TODO: implement keyboardKeyNumpadAdd
  String get keyboardKeyNumpadAdd => 'keyboardKeyNumpadAdd';

  @override
  // TODO: implement keyboardKeyNumpadComma
  String get keyboardKeyNumpadComma => 'keyboardKeyNumpadComma';

  @override
  // TODO: implement keyboardKeyNumpadDecimal
  String get keyboardKeyNumpadDecimal => 'keyboardKeyNumpadDecimal';

  @override
  // TODO: implement keyboardKeyNumpadDivide
  String get keyboardKeyNumpadDivide => 'keyboardKeyNumpadDivide';

  @override
  // TODO: implement keyboardKeyNumpadEnter
  String get keyboardKeyNumpadEnter => 'keyboardKeyNumpadEnter';

  @override
  // TODO: implement keyboardKeyNumpadEqual
  String get keyboardKeyNumpadEqual => 'keyboardKeyNumpadEqual';

  @override
  // TODO: implement keyboardKeyNumpadMultiply
  String get keyboardKeyNumpadMultiply => 'keyboardKeyNumpadMultiply';

  @override
  // TODO: implement keyboardKeyNumpadParenLeft
  String get keyboardKeyNumpadParenLeft => 'keyboardKeyNumpadParenLeft';

  @override
  // TODO: implement keyboardKeyNumpadParenRight
  String get keyboardKeyNumpadParenRight => 'keyboardKeyNumpadParenRight';

  @override
  // TODO: implement keyboardKeyNumpadSubtract
  String get keyboardKeyNumpadSubtract => 'keyboardKeyNumpadSubtract';

  @override
  // TODO: implement keyboardKeyPageDown
  String get keyboardKeyPageDown => 'keyboardKeyPageDown';

  @override
  // TODO: implement keyboardKeyPageUp
  String get keyboardKeyPageUp => 'keyboardKeyPageU';

  @override
  // TODO: implement keyboardKeyPower
  String get keyboardKeyPower => 'keyboardKeyPower';

  @override
  // TODO: implement keyboardKeyPowerOff
  String get keyboardKeyPowerOff => 'keyboardKeyPowerOff';

  @override
  // TODO: implement keyboardKeyPrintScreen
  String get keyboardKeyPrintScreen => 'keyboardKeyPrintScreen';

  @override
  // TODO: implement keyboardKeyScrollLock
  String get keyboardKeyScrollLock => 'keyboardKeyScrollLock';

  @override
  // TODO: implement keyboardKeySelect
  String get keyboardKeySelect => 'keyboardKeySelect';

  @override
  // TODO: implement keyboardKeyShift
  String get keyboardKeyShift => 'keyboardKeyShift';

  @override
  // TODO: implement keyboardKeySpace
  String get keyboardKeySpace => 'keyboardKeySpace';

  @override
  // TODO: implement lookUpButtonLabel
  String get lookUpButtonLabel => 'lookUpButtonLabel';

  @override
  // TODO: implement menuDismissLabel
  String get menuDismissLabel => 'menuDismissLabel';

  @override
  // TODO: implement scanTextButtonLabel
  String get scanTextButtonLabel => 'scanTextButtonLabel';

  @override
  // TODO: implement scrimLabel
  String get scrimLabel => 'scrimLabel';

  @override
  // TODO: implement scrimOnTapHintRaw
  String get scrimOnTapHintRaw => 'scrimOnTapHintRaw';

  @override
  // TODO: implement searchWebButtonLabel
  String get searchWebButtonLabel => 'searchWebButtonLabel';

  @override
  // TODO: implement shareButtonLabel
  String get shareButtonLabel => 'shareButtonLabel';

  @override
  // TODO: implement clearButtonTooltip
  String get clearButtonTooltip => 'clearButtonTooltip';

  @override
  // TODO: implement selectedDateLabel
  String get selectedDateLabel => 'selectedDateLabel';
}
