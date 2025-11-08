import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(
            "Qpon",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black
        ),),
        )

      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        // colors go here
        selectedIndex: currentPageIndex,
        destinations: const <Widget> [
          NavigationDestination( // Favoritos
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite),
            label: 'Favoritos'
          ),
          NavigationDestination( // Calendario
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month),
            label: 'Calendario'
          ),
          NavigationDestination( // Ubicación
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on),
            label: 'Ubicación'
          ),
        ],
        ),
        body: <Widget> [
          // Tab 1
                  Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(child: Text('Tab 1', style: theme.textTheme.titleLarge)),
          ),
        ),
        // Tab 2
                Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(child: Text('Tab 2', style: theme.textTheme.titleLarge)),
          ),
        ),
        // Tab 3
                Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(child: Text('Tab 3', style: theme.textTheme.titleLarge)),
          ),
        ),

        ][currentPageIndex],
    );
  }
}
