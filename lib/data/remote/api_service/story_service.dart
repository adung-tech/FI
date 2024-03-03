import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/remote/api_response/auth/auth_repository.dart';
import 'package:story_app/data/remote/api_response/story/add_story_response.dart';

import '../api_response/story/story_response.dart';

class StoryService {
  static const String baseUrl = "https://story-api.dicoding.dev/v1";
  final authRepository = AuthRepository();
  Future<Map<String, String>> getHeaders() async {
    String token = await authRepository.getToken();
    return {
      "Authorization": "Bearer $token",
    };
}


  Future<List<dynamic>> getAllStories(Map<String, String> headers) async {
    final response =
        await http.get(Uri.parse("$baseUrl/stories"), headers: headers);
    print("hehe ${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body)['listStory'];
    } else {
      throw Exception("Failed to get all stories");
    }
  }

  Future<StoryResponse> getDetailStories(Map<String, String> headers,String storyId) async {
    final response = await http.get(Uri.parse("$baseUrl/stories/$storyId"),headers:await getHeaders());
    print("${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      return StoryResponse.fromMap(json.decode(response.body));
    } else {
      throw Exception("Failed to get all stories");
    }
  }

   Future<AddStoryResponse> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
    Map<String,String> headers
  ) async {

    final uri = Uri.parse("$baseUrl/stories");
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };
  

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(await getHeaders());

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final AddStoryResponse addStoryResponse = AddStoryResponse.fromJson(
        responseData,
      );
      return addStoryResponse;
    } else {
      throw Exception("Upload file error");
    }
  }

  
}
