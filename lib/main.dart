import 'package:estetica_app/presentation/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Supabase
  await Supabase.initialize(
    url: 'https://ufbvcaxhedzauecrgiwd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVmYnZjYXhoZWR6YXVlY3JnaXdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0NTczODgsImV4cCI6MjA1NTAzMzM4OH0.W5EsGhjjMYLCUmyj_OYMONzz3eHmFuQTprX2nqQIMkc',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão Clínica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
