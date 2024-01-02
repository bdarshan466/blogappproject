import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Blog with ChangeNotifier {
  final String id;
  final String title;
  final String detail;
  final String imageUrl;
  String userName;

  Blog({
    @required this.id,
    @required this.title,
    @required this.detail,
    @required this.imageUrl,
    this.userName,
  });
}