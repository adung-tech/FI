import 'package:flutter/material.dart';
import 'package:story_app/data/remote/api_response/auth/auth_repository.dart';

import '../data/remote/api_service/story_service.dart';

enum ResultState { loading, noData, hasData, error }

class ListStoryProvider extends ChangeNotifier {
  final StoryService storyService;
  final AuthRepository authRepository = AuthRepository();


  ListStoryProvider({required this.storyService}) {
    // fetchAllStories();
  }

  ResultState _state = ResultState.loading;

  String _message = '';

  List<dynamic> result = [];

  String get message => _message;

  ResultState get state => _state;

  Future<List<dynamic>> fetchAllStoriess() async {
    final authRepository = AuthRepository();
    final token =  await authRepository.getToken();
    final headers = {
          "Authorization": "Bearer $token",
      };
      _state = ResultState.loading;
    if(token.isNotEmpty){
          try {
          _state = ResultState.loading;
          notifyListeners();
          print("headers $headers");
          final stories = await storyService.getAllStories(headers);
          if (stories.isEmpty) {
            _state = ResultState.noData;
            notifyListeners();
            _message = 'Empty Data';
            result.add(message);
            result[0];
          } else {
            _state = ResultState.hasData;
            result = stories;
            notifyListeners();
            
          }
        } catch (e) {
          _state = ResultState.error;
          notifyListeners();
          _message = 'Error --> $e';
          result.add(_message);
          result[0];
        }
      }else{
        _state = ResultState.error;
        notifyListeners();
        print("token kosong");
      }
      return result;
    }

  void reload() async {
    result = [];
    notifyListeners();

    result = await fetchAllStoriess();
    notifyListeners();
  }
}
