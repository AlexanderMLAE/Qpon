import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

// Imports de tus archivos
import 'package:proyecto_qpon/firebase_options.dart';
import 'custom_widgets/favorites_widget.dart';
import 'custom_widgets/calendar_widget.dart';
import 'custom_widgets/location_widget.dart';
import 'custom_widgets/login_screen.dart';
import 'custom_widgets/register_screen.dart' as reg;
import 'custom_widgets/home_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializamos formato de fechas para el calendario en español
  await initializeDateFormatting('es_ES', null);
  
  // Inicializamos Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qpon',
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja de "Debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      // Rutas de navegación
      routes: {
        '/register': (context) => const reg.RegisterScreen(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const LoginScreen(title: 'qpon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        title: Center(
          child: TextButton(
            onPressed: _openLogin,
            child: const Text(
              'Qpon',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black, 
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on),
            label: 'Ubicación',
          ),
        ],
      ),
      //Se queda el dia marcado del calendario
      body: IndexedStack(
        index: currentPageIndex,
        children: const [
           HomeWidget(),
           FavoritesWidget(),
           CalendarWidget(),
           LocationScreen(locationText: 'Puerto Morelos'),
        ],
      ),
    );
  }
}