import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:story_app/presentation/components/list_item.dart';
import '../../data/remote/api_response/story/story.dart';
import '../../provider/list_story_provider.dart';
import '../components/platform_widget.dart';

class ListStory extends StatefulWidget {
  final Function(String) storyId;
  final Function() onAdd;
  final Function() logout;
  const ListStory({Key? key, required this.storyId, required this.onAdd,required this.logout})
      : super(key: key);

  @override
  _ListStoryState createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildList(BuildContext context) {
    return Consumer<ListStoryProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          state.fetchAllStoriess();
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
        
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.length,
            itemBuilder: (context, index) {
              var listStory = state.result[index];
            
              return ListItem(
                  story: Story.fromMap(listStory),
                  onTapped: () => widget.storyId(listStory['id']));
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story App'),
        actions: [
          IconButton(
            onPressed: () => widget.logout(),
            icon: const Icon(Icons.logout),
           
          )
        ],
      ),
      body: Container(
        child: _buildList(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.onAdd(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Story App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
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
