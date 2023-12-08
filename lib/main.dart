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

// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   // Firebase initialization successful
  //   print("Firebase initialized successfully");
  // } catch (e) {
  //   // Check if the exception is related to Firebase already being initialized
  //   if (e is FirebaseException && e.code == 'already-in-background') {
  //     // Firebase is already initialized in the background
  //     print("Firebase is already initialized in the background");
  //   } else {
  //     // Handle other Firebase initialization errors
  //     print("Firebase initialization failed with error: $e");
  //   }
  // }

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
        home: loginAndSignUp(), // Gantilah Home() dengan widget utama Anda
      ),
    );
  }
}
