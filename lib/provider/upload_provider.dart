import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:story_app/data/remote/api_response/auth/auth_repository.dart';
import 'package:story_app/data/remote/api_service/story_service.dart';
import '../data/remote/api_response/story/add_story_response.dart';

class UploadProvider extends ChangeNotifier {
  final StoryService storyService;
  final AuthRepository authRepository = AuthRepository();

  String token = "";
  void getToken() {
    authRepository.getToken().then((value) {
      token = value;
    });
  }

  Map<String, String> get headers =>
      {"Content-Type": "multipart/form-data", "Authorization": "Bearer $token"};

  UploadProvider(this.storyService) {
    getToken();
  }

  bool isUploading = false;
  String message = "";
  bool error = true;
  AddStoryResponse? addStoryResponse;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      message = "";
      addStoryResponse = null;
      isUploading = true;
      notifyListeners();

      addStoryResponse = await storyService.uploadDocument(
          bytes, fileName, description, headers);
      message = addStoryResponse?.message ?? "success";
      error = addStoryResponse?.error ?? true;
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  Future<List<int>> resizeImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    bool isWidthMoreTaller = image.width > image.height;
    int imageTall = isWidthMoreTaller ? image.width : image.height;
    double compressTall = 1;
    int length = imageLength;
    List<int> newByte = bytes;

    do {
      compressTall -= 0.1;

      final newImage = img.copyResize(
        image,
        width: isWidthMoreTaller ? (imageTall * compressTall).toInt() : null,
        height: !isWidthMoreTaller ? (imageTall * compressTall).toInt() : null,
      );

      length = newImage.length;
      if (length < 1000000) {
        newByte = img.encodeJpg(newImage);
      }
    } while (length > 1000000);

    return newByte;
  }
}
