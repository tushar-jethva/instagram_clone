import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/mobilescreen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen.dart';
import 'package:instagram_clone/responsive/webscreen_layout.dart';
import 'package:instagram_clone/routes/routes.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utills/colors.dart';
import 'package:instagram_clone/utills/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: mobileBackgroundColor));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const MyResponsiveScreen(
                    webScreenLayout: MyWebScreenLayout(),
                    mobileScreenLayout: MyMobileScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loader();
            }
            return const MyLoginScreen();
          }),
        ),
        // home: MyProfileScreen(),
      ),
    );
  }
}
