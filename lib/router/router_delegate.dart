
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/remote/api_response/auth/auth_repository.dart';
import 'package:story_app/presentation/ui/add_story.dart';

import 'package:story_app/presentation/ui/detail_story.dart';

import 'package:story_app/presentation/ui/list_story.dart';

import '../presentation/ui/login_screen.dart';
import '../presentation/ui/register_screen.dart';
import '../presentation/ui/splash_screen.dart';
import '../provider/list_story_provider.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  late final GlobalKey<NavigatorState> _navigatorKey;

  final AuthRepository authRepository;

  String? selectedStory;

  bool? add;

  List<Page> historyStack = [];

  bool? isLoggedIn;

  bool isRegister = false;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLogin();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
     
      historyStack = _loggedOutStack;
    }
    return Navigator(
        key: navigatorKey,
        pages: historyStack,
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }

          selectedStory = null;
          notifyListeners();

          add = null;
          notifyListeners();

          isRegister = false;
          notifyListeners();

          return true;
        });
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("ListStory"),
          child: ListStory(
            storyId: (String storyId) {
              selectedStory = storyId;
              notifyListeners();
            
            },
            onAdd: () {
              add = true;
              notifyListeners();
            },
            logout: () {
              isLoggedIn = false;
              notifyListeners();
              authRepository.deleteToken();
              authRepository.isLogout();
            },
          ),
        ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey("DetailsScreen-$selectedStory"),
            child: DetailStory(
              storyId: selectedStory ?? "",
            ),
          ),
        if (add != null)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            child: AddStory(
              onHome: (context) {
                add = null;
                notifyListeners();
                context.read<ListStoryProvider>().reload();
                context.read<ListStoryProvider>().fetchAllStoriess();

              },
            ),
          ),
      ];

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
