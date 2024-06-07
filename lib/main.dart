import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/loginAndSignUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stavax_new/screen/main_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListOfSongs()),
        ChangeNotifierProvider(
          create: (context) => UsersProvider(),
          // Gantilah UserProvider dengan nama kelas Anda
        ),
        ChangeNotifierProvider(create: (context) => Playlist()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stavax',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: MainScreen(), // Gantilah Home() dengan widget utama Anda
        builder: EasyLoading.init(),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration =
        const Duration(seconds: 3) // Set the display duration to 3 seconds
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false;
}
