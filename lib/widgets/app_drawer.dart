import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/home_page.dart';
import 'package:sampleproject/providers/auth.dart';
import 'package:sampleproject/screens/manage_user_blogs.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Hello Friend!",
              style: TextStyle(
                fontFamily: "saonara",
                fontWeight: FontWeight.bold,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text(
              "Blogs",
              style: TextStyle(
                fontFamily: "saonara",
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              "Manage Blogs",
              style: TextStyle(
                fontFamily: "saonara",
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageUserBlogs.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Logout",
              style: TextStyle(
                fontFamily: "saonara",
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
        ],
      ),
    );
  }
}
