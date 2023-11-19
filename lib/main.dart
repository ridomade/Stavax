import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/artist.dart';
import 'package:stavax_new/screen/login.dart';
import 'package:stavax_new/screen/loginAndSignUp.dart';
import 'package:stavax_new/screen/profile.dart';
import 'package:stavax_new/screen/signUp.dart';
import '../screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/songsclass.dart';

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
        ChangeNotifierProvider(
          create: (context) => UsersProvider(),
          // Gantilah UserProvider dengan nama kelas Anda
        ),
        ChangeNotifierProvider(create: (context) => Playlist())
      ],
      child: MaterialApp(
        title: 'Stavax',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: loginAndSignUp(), // Gantilah Home() dengan widget utama Anda
      ),
    );
  }
}
