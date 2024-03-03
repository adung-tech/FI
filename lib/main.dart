import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/remote/api_response/auth/auth_repository.dart';
import 'package:story_app/data/remote/api_service/auth_service.dart';
import 'package:story_app/data/remote/api_service/story_service.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/provider/upload_provider.dart';
import 'package:story_app/router/router_delegate.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({Key? key}) : super(key: key);

  @override
  _StoryAppState createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthRepository authRepository;
  late AuthService authService;
  late AuthProvider authProvider;
  late UploadProvider uploadProvider;
  late StoryProvider storyProvider;
  late ListStoryProvider listStoryProvider;

  String? selectedQuote;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    authService = AuthService();
    uploadProvider = UploadProvider(StoryService());
    storyProvider = StoryProvider();
    
    authProvider =
        AuthProvider(authRepository: authRepository, authService: authService);
    myRouterDelegate = MyRouterDelegate(authRepository);
    listStoryProvider = ListStoryProvider(storyService: StoryService());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
      [
        
        ChangeNotifierProvider(create: (context) => authProvider),

        ChangeNotifierProvider(create: (context) => uploadProvider),

        ChangeNotifierProvider(create: (context) => storyProvider),

        ChangeNotifierProvider(create: (context) => listStoryProvider)

      ],
      child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Story App',
            home: Router(
              routerDelegate: myRouterDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ))
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
