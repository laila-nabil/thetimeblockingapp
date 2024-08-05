import 'package:flutter/widgets.dart';

enum AnalyticsEvents {
  onBoardingStep1ConnectClickup,
  onBoardingStep1SignInSupabase,
  onBoardingStep1Start,
  onBoardingStep1Demo,
  onBoardingStep2Back,
  onBoardingStep2Next,
  onBoardingStep2Skip,
  onBoardingStep3Back,
  onBoardingStep3Next,
  onBoardingStep3Skip,
  onBoardingStep4Connect,
  onBoardingStep4CopyLink,
  onBoardingStep2Demo,
  onBoardingStep3Demo,
  onBoardingStep4Demo,
  createTask,
  moveTaskBetweenLists,
  updateTask,
  deleteTask,
  completeTask,
  duplicateTask,
  createList,
  editList,
  deleteList,
  createFolder,
  editFolder,
  deleteFolder,
  createTag,
  updateTag,
  deleteTag,
  changeLanguage,
  launchUrl,
  connectClickup,
  openDemo,
  getData, signOut,
  addTagToTask,
  removeTagToTask,
  signIn
}

enum AnalyticsEventParameter { language, link, status, error ,data}

abstract class Analytics {
  Future<void> initialize();

  Future<void> logAppOpen();

  Future<void> logEvent(String eventName, {Map<String, Object>? parameters});

  Future<void> setCurrentScreen(String screenName);

  Future<void> setUserId(String userId);

  Future<void> resetUser();

  late NavigatorObserver navigatorObserver;
}
