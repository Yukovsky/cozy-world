import 'package:strings_api/presentation_strings_repository.dart';

import 'assets/app_assets.dart';
import 'assets/counter_assets.dart';
import 'assets/history_assets.dart';
import 'assets/support_assets.dart';
import 'common/error_strings.dart';
import 'common/navigation_strings.dart';
import 'modules/counter/counter_strings.dart';
import 'modules/history/history_strings.dart';
import 'modules/support/support_strings.dart';

/// Публичная реализация [PresentationStringsRepository] для релизной сборки.
class PresentationStringsImpl implements PresentationStringsRepository {
  @override
  String get acquaintanceHeading => CounterStrings.acquaintanceHeading;

  @override
  String get appTitle => NavigationStrings.appTitle;

  @override
  String get backPressConfirmation => NavigationStrings.backPressConfirmation;

  @override
  String get categoriesEmpty => SupportStrings.categoriesEmpty;

  @override
  String get categoriesLoadError => SupportStrings.categoriesLoadError;

  @override
  String get changeFailed => SupportStrings.changeFailed;

  @override
  String get changeSuccess => SupportStrings.changeSuccess;

  @override
  String get changeSuccessButNotUpdated =>
      SupportStrings.changeSuccessButNotUpdated;

  @override
  String get counterCatsAnimation => CounterAssets.catsAnimation;

  @override
  String counterErrorMessage(String error) =>
      CounterStrings.errorMessage(error);

  @override
  String get counterGreeting => CounterStrings.greeting;

  @override
  String get counterHeartsAnimation => CounterAssets.heartsAnimation;

  @override
  String get counterLabel => NavigationStrings.counterLabel;

  @override
  String get counterMouseCurious => CounterAssets.mouseCurious;

  @override
  String get counterMouseGirlSuspicious => CounterAssets.mouseGirlSuspicious;

  @override
  String get counterMouseHappy => CounterAssets.mouseHappy;

  @override
  String get counterMouseKiss => CounterAssets.mouseKiss;

  @override
  String get counterMouseSleep => CounterAssets.mouseSleep;

  @override
  String get counterPageTitle => CounterStrings.pageTitle;

  @override
  String get counterTooltip => NavigationStrings.counterTooltip;

  @override
  String get counterDatesNotLoaded => CounterStrings.datesNotLoaded;

  @override
  String get counterUnknownError => CounterStrings.unknownError;

  @override
  String get dayUnitsContinuation => CounterStrings.dayUnitsContinuation;

  @override
  String get daysSinceAcquaintance => CounterStrings.daysSinceAcquaintance;

  @override
  String get emptyCategory => SupportStrings.emptyCategory;

  @override
  String get emptyStateSad => AppAssets.emptyStateSad;

  @override
  String get errorTitle => ErrorStrings.errorTitle;

  @override
  String get happyMomentsCaption => CounterStrings.happyMomentsCaption;

  @override
  String get happyMomentsHeading => CounterStrings.happyMomentsHeading;

  @override
  String get historyCatCouple => HistoryAssets.catCouple;

  @override
  String get historyCatPaw => HistoryAssets.catPaw;

  @override
  String get historyCatPrint => HistoryAssets.catPrint;

  @override
  String get historyEmptyStateMessage => HistoryStrings.emptyStateMessage;

  @override
  String get historyInstructionText => HistoryStrings.instructionText;

  @override
  String get historyLabel => NavigationStrings.historyLabel;

  @override
  String get historyMessage => HistoryStrings.message;

  @override
  String get historyPageTitle => HistoryStrings.pageTitle;

  @override
  String get historyTooltip => NavigationStrings.historyTooltip;

  @override
  String get infinityValue => CounterStrings.infinityValue;

  @override
  String get loadingAnimation => AppAssets.loadingAnimation;

  @override
  String get markAsRead => SupportStrings.markAsRead;

  @override
  String get moreInfoPrefix => ErrorStrings.moreInfoPrefix;

  @override
  String get noMessageToday => SupportStrings.noMessageToday;

  @override
  String get openWhenHeading => SupportStrings.openWhenHeading;

  @override
  String get pageNotFound => NavigationStrings.pageNotFound;

  @override
  String get readMessagesHeading => SupportStrings.readMessagesHeading;

  @override
  String get relationshipHeading => CounterStrings.relationshipHeading;

  @override
  String get removeFromRead => SupportStrings.removeFromRead;

  @override
  String get snackbarErrorTitle => ErrorStrings.snackbarErrorTitle;

  @override
  String get supportDataLoadError => SupportStrings.dataLoadError;

  @override
  String get supportHeartAnimation => SupportAssets.heartAnimation;

  @override
  String get supportLabel => NavigationStrings.supportLabel;

  @override
  String get supportMouseGirlSad => SupportAssets.mouseGirlSad;

  @override
  String supportOperationError(String error) =>
      SupportStrings.operationError(error);

  @override
  String get supportPageTitle => SupportStrings.pageTitle;

  @override
  String get supportTooltip => NavigationStrings.supportTooltip;

  @override
  String get todayMessageHeading => SupportStrings.todayMessageHeading;

  @override
  String get todayMessageLoadError => SupportStrings.todayMessageLoadError;

  @override
  String get unknownClassPrefix => ErrorStrings.unknownClassPrefix;
}
