import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/providers/blogs.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail-screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedBlog = Provider.of<Blogs>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2d3447),
        title: Text(
          loadedBlog.title,
          style: TextStyle(
            fontFamily: "saonara",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedBlog.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedBlog.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "saonara",
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                loadedBlog.detail,
                style: TextStyle(
                  fontFamily: "saonara",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
