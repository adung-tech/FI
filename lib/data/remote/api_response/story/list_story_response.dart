

import 'package:story_app/data/remote/api_response/story/story.dart';

class ListStoryResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  ListStoryResponse(
      {required this.error, required this.message, required this.listStory});

  factory ListStoryResponse.fromMap(Map<String, dynamic> map) {
    return ListStoryResponse(
        error: map["error"],
        message: map["message"],
        listStory: List<Story>.from((map["listStory"] as List)
            .map((datas) => Story.fromMap(datas))
            .where((article) =>
                article.name != null &&
                article.photoUrl != null &&
                article.description != null &&
                article.createdAt != null)));
  }
}
