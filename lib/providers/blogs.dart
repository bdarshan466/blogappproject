import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampleproject/providers/blog.dart';

class Blogs with ChangeNotifier {
  List<Blog> _blogs = [];

  Blog findById(String id) {
    return _blogs.firstWhere((blog) => blog.id == id);
  }

  List<Blog> get blogs {
    return [..._blogs];
  }

  String userId;
  String userName;

  final _auth = FirebaseAuth.instance;

  Blogs(this._blogs);

  Future<void> fetchAndSetBlogs([bool filterByUser = false]) async {
    userId = _auth.currentUser.uid;
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://blog-app-flutter-43068-default-rtdb.firebaseio.com/blogs.json?$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Blog> loadedBlogs = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((blogId, blogData) {
        loadedBlogs.add(
          Blog(
            id: blogId,
            title: blogData["title"],
            userName: blogData["userName"],
            detail: blogData["detail"],
            imageUrl: blogData["imageUrl"],
          ),
        );
      });
      _blogs = loadedBlogs;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addBlog(Blog blog) async {
    userId = _auth.currentUser.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((DocumentSnapshot) => userName = DocumentSnapshot["name"]);
    final url =
        'https://blog-app-flutter-43068-default-rtdb.firebaseio.com/blogs.json?';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "title": blog.title,
          "detail": blog.detail,
          "imageUrl": blog.imageUrl,
          "userName": userName,
          "creatorId": userId,
        }),
      );

      final newBlog = Blog(
        id: json.decode(response.body)["name"],
        title: blog.title,
        detail: blog.detail,
        imageUrl: blog.imageUrl,
        userName: userName,
      );

      _blogs.add(newBlog);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateBlog(String id, Blog newBlog) async {
    final blogIndex = _blogs.indexWhere((blog) => blog.id == id);
    if (blogIndex >= 0) {
      final url =
          'https://blog-app-flutter-43068-default-rtdb.firebaseio.com/blogs/$id.json?';
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          "title": newBlog.title,
          "detail": newBlog.detail,
          "imageUrl": newBlog.imageUrl,
        }),
      );
      _blogs[blogIndex] = newBlog;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://blog-app-flutter-43068-default-rtdb.firebaseio.com/blogs/$id.json?';
    final existingBlogIndex = _blogs.indexWhere((blog) => blog.id == id);
    var existingBlog = _blogs[existingBlogIndex];
    _blogs.removeAt(existingBlogIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _blogs.insert(existingBlogIndex, existingBlog);
      notifyListeners();
      throw HttpException("Could not delete blog.");
    }
    existingBlog = null;
  }
}
