/// Контракт строк и путей ассетов для presentation-слоя.
abstract class PresentationStringsRepository {
  // Common navigation and errors
  String get appTitle;
  String get historyTooltip;
  String get historyLabel;
  String get counterTooltip;
  String get counterLabel;
  String get supportTooltip;
  String get supportLabel;
  String get backPressConfirmation;
  String get pageNotFound;
  String get errorTitle;
  String get snackbarErrorTitle;
  String get unknownClassPrefix;
  String get moreInfoPrefix;

  // Counter module
  String get counterPageTitle;
  String get daysSinceAcquaintance;
  String get acquaintanceHeading;
  String get relationshipHeading;
  String get happyMomentsHeading;
  String get happyMomentsCaption;
  String get counterGreeting;
  String get counterDatesNotLoaded;
  String get counterUnknownError;
  String counterErrorMessage(String error);
  String get dayUnitsContinuation;
  String get infinityValue;

  // History module
  String get historyPageTitle;
  String get historyMessage;
  String get historyInstructionText;
  String get historyEmptyStateMessage;

  // Support module
  String get supportPageTitle;
  String get todayMessageHeading;
  String get openWhenHeading;
  String get readMessagesHeading;
  String get noMessageToday;
  String get emptyCategory;
  String get todayMessageLoadError;
  String get categoriesLoadError;
  String get categoriesEmpty;
  String get markAsRead;
  String get removeFromRead;
  String get supportDataLoadError;
  String supportOperationError(String error);
  String get changeSuccess;
  String get changeSuccessButNotUpdated;
  String get changeFailed;

  // Assets
  String get loadingAnimation;
  String get emptyStateSad;
  String get counterMouseCurious;
  String get counterMouseGirlSuspicious;
  String get counterMouseSleep;
  String get counterMouseKiss;
  String get counterMouseHappy;
  String get counterCatsAnimation;
  String get counterHeartsAnimation;
  String get historyCatPrint;
  String get historyCatCouple;
  String get historyCatPaw;
  String get supportHeartAnimation;
  String get supportMouseGirlSad;
}
