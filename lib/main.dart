import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/home_page.dart';
import 'package:sampleproject/providers/auth.dart';
import 'package:sampleproject/providers/blogs.dart';
import 'package:sampleproject/screens/auth_screen.dart';
import 'package:sampleproject/screens/edit_blog_screen.dart';
import 'package:sampleproject/screens/manage_user_blogs.dart';
import 'package:sampleproject/screens/splash_screen.dart';

import 'screens/detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Blogs>(
          update: (ctx, auth, previousBlogs) =>
              Blogs(previousBlogs == null ? [] : previousBlogs.blogs),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFF2d3447),
            primarySwatch: Colors.blueGrey,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (userSnapshot.hasData) {
                return HomePage();
              }
              return AuthScreen();
            },
          ),
          routes: {
            HomePage.routeName: (context) => HomePage(),
            DetailScreen.routeName: (context) => DetailScreen(),
            EditBlogScreen.routeName: (context) => EditBlogScreen(),
            ManageUserBlogs.routeName: (context) => ManageUserBlogs(),
          },
        ),
      ),
    );
  }
}
