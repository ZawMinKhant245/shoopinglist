import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/category.dart';
import 'package:shoopinglist/model/expense.dart';
import 'package:shoopinglist/provider/category_provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';
import 'package:shoopinglist/screens/add_shopping_list_details.dart';
import 'package:shoopinglist/screens/home_screen.dart';
import 'package:shoopinglist/screens/sign_in_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ExpenseAdapter());
 // await Hive.openBox<Category>('categories');
 // await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>CategoryProvider()),
          ChangeNotifierProvider(create: (context)=>ExpenseProvider()),
        ],
      child:  MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );

  }
}


