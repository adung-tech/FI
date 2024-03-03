import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/list_story_provider.dart';
import '../../provider/story_provider.dart';
import '../../provider/upload_provider.dart';

class AddStory extends StatefulWidget {
  final Function(BuildContext) onHome;
  const AddStory({super.key, required this.onHome});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Story"),
        actions: [
          IconButton(
            onPressed: () => {
              if (descriptionController.text.isNotEmpty)
                {
                  _onUpload(descriptionController.text.toString()),
                  context.read<ListStoryProvider>().reload(),
                  context.read<ListStoryProvider>().fetchAllStoriess()

                  
                }
              else
                {
                  scaffoldMessengerState.showSnackBar(
                    const SnackBar(
                        content: Text("Image or  Description cannot be empty")),
                  )
                }
            },
            icon: context.watch<UploadProvider>().isUploading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.upload),
            tooltip: "Unggah",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: context.watch<StoryProvider>().imagePath == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 100,
                      ),
                    )
                  : _showImage(),
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Enter description",
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _onGalleryView(),
                    child: const Text("Gallery"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onUpload(String description) async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();

    final homeProvider = context.read<StoryProvider>();
    final imagePath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(newBytes, fileName, description);

    if (uploadProvider.addStoryResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
    }

    if (uploadProvider.error) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(uploadProvider.message)),
      );
    } else {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(uploadProvider.message)),
      );
      widget.onHome(context);
     
    }
  }

  _onGalleryView() async {
    final provider = context.read<StoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<StoryProvider>().imagePath;
    return kIsWeb
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child:Image.network(
              imagePath.toString(),
              fit: BoxFit.contain,
            )
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.file(
              File(imagePath.toString()),
              fit: BoxFit.contain,
            ),
          );
  }
}
