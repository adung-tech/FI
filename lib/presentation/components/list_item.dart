import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import '../../data/remote/api_response/story/story.dart';

class ListItem extends StatelessWidget {
  final Story story;
  final Function() onTapped;
  const ListItem({Key? key, required this.story, required this.onTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16.0),
        ),
      ),
      elevation: 10.0,
      shadowColor: Colors.black,
      margin: const EdgeInsets.all(10.0),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: story.photoUrl ?? "",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
             title: Text(story.name ?? ""),   
             onTap: () => onTapped(),
            
            )
          ),
          
    );
  }
}
