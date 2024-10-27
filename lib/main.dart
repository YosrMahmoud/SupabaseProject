import 'package:ecommerce/HomeScreen.dart';
import 'package:ecommerce/LoginPage.dart';
import 'package:ecommerce/RegisterPage.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qzhaaelnovwbtrgftsak.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF6aGFhZWxub3Z3YnRyZ2Z0c2FrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg5OTIwMDYsImV4cCI6MjA0NDU2ODAwNn0.tnuR8B4hFKmaZt5s7qRrszxQbn0MGdCSwJMhxHazZGs',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Countries',
initialRoute: LoginPage.routeName,
  routes: {
  LoginPage.routeName : (context) => LoginPage(),
    RegisterPage.routeName : (context) => RegisterPage(),
    HomeScreen.routeName : (context) => HomeScreen()
  },
);
}
}

// class HomePage extends StatefulWidget {
// const HomePage({super.key});
//
// @override
// State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
// final _future = Supabase.instance.client
//     .from('product')
//     .select();
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// body: FutureBuilder(
// future: _future,
// builder: (context, snapshot) {
// if (!snapshot.hasData) {
// return const Center(child: CircularProgressIndicator());
// }
// final countries = snapshot.data!;
// return ListView.builder(
// itemCount: countries.length,
// itemBuilder: ((context, index) {
// final country = countries[index];
// return ListTile(
// title: Text(country['name']),
// );
// }),
// );
// },
// ),
// );
// }
// }