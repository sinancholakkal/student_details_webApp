import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_detiails/db/functions/data/data_model.dart';
import 'package:student_detiails/db/functions/db_functions.dart';
import 'package:student_detiails/pages/home_screen.dart';
import 'package:student_detiails/pages/splash_screen.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(StudentModelAdapter().typeId)){
     Hive.registerAdapter(StudentModelAdapter());
  }
  getAllStudent();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
      ),
      home: const SplashScreen(),
      routes: {
        'HomeScreen':(context)=>const HomeScreen()
      },
    );
  }
}