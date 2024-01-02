import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/providers/blogs.dart';
import 'package:sampleproject/screens/edit_blog_screen.dart';
import 'package:sampleproject/widgets/app_drawer.dart';
import 'package:sampleproject/widgets/home_page_blogs.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home-page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Blogs>(context).fetchAndSetBlogs().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final blogsData = Provider.of<Blogs>(context);
    final blogs = blogsData.blogs;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditBlogScreen.routeName);
            },
          ),
        ],
        title: Text(
          "Blogs",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "saonara",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF2d3447),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : blogs.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: blogs.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    value: blogs[index],
                    child: HomePageBlogs(),
                  ),
                ),
    );
  }
}
