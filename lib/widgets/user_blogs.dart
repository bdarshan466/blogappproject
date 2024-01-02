import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/providers/blogs.dart';
import 'package:sampleproject/screens/edit_blog_screen.dart';

class UserBlogs extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserBlogs(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  width: 300,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "saonara",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditBlogScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit"),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () async {
                    try {
                      await Provider.of<Blogs>(context, listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Deleting failed!",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
