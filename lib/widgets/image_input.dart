import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final dynamic initImage;

  ImageInput(this.onSelectImage, this.initImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  void initState() {
    if (widget.initImage == null) {
      return;
    }
    setState(() {
      _storedImage = widget.initImage;
    });
    widget.onSelectImage(_storedImage);
    // TODO: implement initState
    super.initState();
  }

  dynamic _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    widget.onSelectImage(_storedImage);
  }

  Future<void> _selectPicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    widget.onSelectImage(_storedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: _storedImage != null
              ? _storedImage is File
                  ? Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.network(
                      _storedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
              : Text(
                  "Please Select or Take an Image.",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                onPressed: _takePicture,
                icon: Icon(Icons.camera),
                label: Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                onPressed: _selectPicture,
                icon: Icon(Icons.photo),
                label: Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
