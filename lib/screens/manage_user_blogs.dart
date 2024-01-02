import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/providers/blogs.dart';
import 'package:sampleproject/screens/edit_blog_screen.dart';
import 'package:sampleproject/widgets/app_drawer.dart';
import 'package:sampleproject/widgets/user_blogs.dart';

class ManageUserBlogs extends StatelessWidget {
  static const routeName = "/manage-blogs";

  Future<void> _refreshBlogs(BuildContext context) async {
    await Provider.of<Blogs>(context, listen: false).fetchAndSetBlogs(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Your Blogs",
          style: TextStyle(
            fontFamily: "saonara",
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditBlogScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshBlogs(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshBlogs(context),
                    child: Consumer<Blogs>(
                      builder: (ctx, blogsData, _) => blogsData.blogs.isEmpty
                          ? Center(
                              child: Text(
                                "Create your first Blog.",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: ListView.builder(
                                itemCount: blogsData.blogs.length,
                                itemBuilder: (_, index) => Column(
                                  children: [
                                    UserBlogs(
                                      blogsData.blogs[index].id,
                                      blogsData.blogs[index].title,
                                      blogsData.blogs[index].imageUrl,
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
      ),
    );
  }
}
