import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Imports de tus archivos
import 'package:proyecto_qpon/database/firebase_options.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/home/filters/calendar_widget.dart';
import 'features/map/map_screen.dart';
import 'features/login/login_screen.dart';
import 'features/login/register_screen.dart' as reg;
import 'features/home/home_screen.dart';
import 'features/login/profile_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos formato de fechas para el calendario en español
  await initializeDateFormatting('es_ES', null);

  // Inicializamos Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  WidgetsFlutterBinding.ensureInitialized();
  const String accessToken = String.fromEnvironment("ACCESS_TOKEN");
  MapboxOptions.setAccessToken(accessToken);
  runApp(const MyApp());
}

/// Main app that shows a title and bottom navigation bar
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
      routes: {'/register': (context) => const reg.RegisterScreen()},
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return snapshot.data == null
              ? LoginScreen(title: 'Qpon')
              : MyHomePage();
        },
      ),
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
      MaterialPageRoute<void>(
        builder: (context) => const LoginScreen(title: 'qpon'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 18, 47),
        centerTitle:
            true, // Esto obliga al título a centrarse en todas las plataformas
        title: TextButton(
          onPressed: _openLogin,
          child: const Text(
            'Qpon',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return IconButton(
                iconSize: 45, // Aumenta el tamaño interactuable del botón
                icon: user?.photoURL != null
                    ? CircleAvatar(
                        radius:
                            22, // Aumenta el tamaño de la foto de perfil (antes 15)
                        backgroundImage: NetworkImage(user!.photoURL!),
                        backgroundColor: Colors.black87,
                      )
                    : const Icon(
                        Icons.account_circle,
                        size:
                            45, // Aumenta el tamaño del icono por defecto (antes 30)
                      ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePanel(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            iconTheme: WidgetStateProperty.all(
              const IconThemeData(color: Colors.black),
            ),
          ),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          backgroundColor: const Color.fromARGB(255, 227, 18, 47),
          indicatorColor: Colors.transparent,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_outline),
              label: 'Favoritos',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.calendar_month),
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Calendario',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.location_on),
              icon: Icon(Icons.location_on_outlined),
              label: 'Ubicación',
            ),
          ],
        ),
      ),
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
