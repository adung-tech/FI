

import 'package:story_app/data/remote/api_response/story/story.dart';

class StoryResponse {
  final bool error;
  final String message;
  final Story story;

  StoryResponse(
      {required this.error, required this.message, required this.story});

  factory StoryResponse.fromMap(Map<String, dynamic> map) {
    return StoryResponse(
        error: map["error"],
        message: map["message"],
        story: Story.fromMap(map["story"]));
  }
}
