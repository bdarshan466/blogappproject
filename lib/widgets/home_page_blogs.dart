import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/providers/blog.dart';
import 'package:sampleproject/screens/detail_screen.dart';

class HomePageBlogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blog = Provider.of<Blog>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
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
                    blog.imageUrl,
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
                      blog.title,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: "saonara",
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Created By : " + blog.userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: "saonara",
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(DetailScreen.routeName, arguments: blog.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Read Now",
                        style: TextStyle(
                            fontFamily: "saonara",
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
