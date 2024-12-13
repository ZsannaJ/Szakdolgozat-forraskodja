import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ranker/firebase/FirestoreService_Lissen.dart';
import 'package:ranker/firebase_options.dart';
import 'package:ranker/view/loading_screen.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirestoreServiceLissen firestoreService = FirestoreServiceLissen();
  firestoreService.listenToPlayerChanges();
  firestoreService.listenToTeamChanges();
  firestoreService.listenToMatchIndividualChanges();
  firestoreService.listenToMatchTeamChanges();
  firestoreService.listenToLeagueIndividualChanges();
  firestoreService.listenToLeagueTeamChanges();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Bungee',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}