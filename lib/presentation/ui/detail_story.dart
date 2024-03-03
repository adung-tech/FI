import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:story_app/data/remote/api_service/story_service.dart';

import '../../data/remote/api_response/auth/auth_repository.dart';
import '../../data/remote/api_response/story/story_response.dart';
import '../components/platform_widget.dart';

class DetailStory extends StatefulWidget {
  String storyId;
  DetailStory({Key? key, required this.storyId}) : super(key: key);

  @override
  _DetailStoryState createState() => _DetailStoryState();
}

class _DetailStoryState extends State<DetailStory> {
  late Future<StoryResponse> storyResponse;
  final AuthRepository authRepository = AuthRepository();
  
  String token = "";
   void getToken() {
    authRepository.getToken().then((value) => token = value);
  }

  Map<String, String> get headers => { "Authorization": "Bearer $token"};


  @override
  void initState() {
    super.initState();
    storyResponse = StoryService().getDetailStories(headers, widget.storyId);
  }

  @override
  Widget _buildDetail(BuildContext context) {
    return FutureBuilder(
        future: storyResponse,
        builder: (BuildContext context, AsyncSnapshot<StoryResponse> snapshot) {
          var state = snapshot.connectionState;
          if (state == ConnectionState.done) {
            if (snapshot.hasData) {
              var data = snapshot.data!.story;
              return Container(
                child: Column(
                  children: [
                    CachedNetworkImage(
                        imageUrl: data.photoUrl ?? "",
                        fit: BoxFit.fill,
                        width: 400,
                        height: 250,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator()),
                    const SizedBox(height: 25),
                    Text(data.name ?? ""),
                    const SizedBox(height: 10),
                    Text(data.description ?? "")
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Material(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return const Material(child: Text(''));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Story'),
      ),
      body: Container(
        child: _buildDetail(context),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detail Story'),
        transitionBetweenRoutes: false,
      ),
      child: _buildDetail(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
