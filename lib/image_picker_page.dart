import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plushie_app/tag_record.dart';
import 'package:plushie_app/web_manager.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  XFile? _mediaFile;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFile = value;
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFile != null) {
      return Semantics(
            label: 'image_picker_example_picked_image',
            child: kIsWeb
                ? Image.network(_mediaFile!.path)
                : Image.file(
                        File(_mediaFile!.path),
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                              child:
                                  Text('This image type is not supported'));
                        },
                      ),
          );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
        setState(() {
          if (response.file == null) {
            _setImageFileListFromFile(response.file);
          } else {
            _mediaFile = response.file;
          }
        });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

   Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool isMedia = false,
  }) async {
    if (context.mounted) {
        if (isMedia) {
            try {
              final XFile? media = await _picker.pickMedia();
                setState(() {
                  _mediaFile = media;
                });
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
        } else {
            try {
              final XFile? pickedFile = await _picker.pickImage(source: source);
              setState(() {
                _setImageFileListFromFile(pickedFile);
              });
            } catch (e) {
              setState(() {
                _pickImageError = e;
              });
            }
        }
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _previewImage();
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : _previewImage(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
          Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                  onPressed: () {
                  TagRecord.profilePictureUrl = _mediaFile!.path.toString();
                  WebManager().uploadImage(_mediaFile!);
                  Navigator.of(context).pop();
                  },
                shape: CircleBorder(),
                heroTag: 'confirm',
                tooltip: 'Confirm',
                backgroundColor: Colors.green,
                child: const Icon(Icons.check),
              )
          )
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
