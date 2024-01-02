import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/providers/blog.dart';
import 'package:sampleproject/providers/blogs.dart';
import 'package:sampleproject/widgets/image_input.dart';

class EditBlogScreen extends StatefulWidget {
  static const routeName = '/blog-screen';

  @override
  State<EditBlogScreen> createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  final _form = GlobalKey<FormState>();
  dynamic _pickedImage;

  String getRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  var _editedBlog = Blog(
    id: null,
    title: "",
    detail: "",
    imageUrl: "",
  );

  var _initValues = {
    "title": "",
    "detail": "",
    "imageUrl": "",
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final blogId = ModalRoute.of(context).settings.arguments as String;
      if (blogId != null) {
        _editedBlog =
            Provider.of<Blogs>(context, listen: false).findById(blogId);
        _initValues = {
          "title": _editedBlog.title,
          "detail": _editedBlog.detail,
          "imageUrl": _editedBlog.imageUrl,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.red,
          content: Text("Image is required!"),
        ),
      );
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      if (_pickedImage is File) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("blog_images")
            .child(getRandomString(5) + ".jpg");
        await ref.putFile(_pickedImage);

        final url = await ref.getDownloadURL();

        _editedBlog = Blog(
          id: _editedBlog.id,
          title: _editedBlog.title,
          detail: _editedBlog.detail,
          imageUrl: url,
        );
      } else {
        _editedBlog = Blog(
          id: _editedBlog.id,
          title: _editedBlog.title,
          detail: _editedBlog.detail,
          imageUrl: _pickedImage,
        );
      }
    }

    if (_editedBlog.id != null) {
      await Provider.of<Blogs>(context, listen: false)
          .updateBlog(_editedBlog.id, _editedBlog);
    } else {
      try {
        await Provider.of<Blogs>(context, listen: false).addBlog(_editedBlog);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred!"),
            content: Text("Something went wrong."),
            actions: [
              TextButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _selectImage(dynamic pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          "Your Blog",
          style: TextStyle(
            fontFamily: "saonara",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: 5),
                    TextFormField(
                      initialValue: _initValues["title"],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter title.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBlog = Blog(
                          id: _editedBlog.id,
                          title: value,
                          detail: _editedBlog.detail,
                          imageUrl: _editedBlog.imageUrl,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ImageInput(
                        _selectImage,
                        (_initValues["imageUrl"] == ""
                            ? null
                            : _initValues["imageUrl"])),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: _initValues["detail"],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Blog detail",
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter detail.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBlog = Blog(
                          id: _editedBlog.id,
                          title: _editedBlog.title,
                          detail: value,
                          imageUrl: _editedBlog.imageUrl,
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white),
                      ),
                      onPressed: _saveForm,
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
