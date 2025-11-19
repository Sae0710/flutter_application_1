import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'home_page.dart';
import 'data_window_page.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.isEmpty) {
    runApp(const MyApp());
  } else {
    // Argumentos presentes = Abrir una ventana secundaria
    final windowId = int.parse(args[0]);
    final arguments = jsonDecode(args[1]);

    final String dataType = arguments['dataType'] ?? 'unknown';
    final String title = arguments['title'] ?? 'Detalle';

    runApp(
      DataWindowApp(
        windowController: WindowController.fromWindowId(windowId.toString()),
        dataType: dataType,
        title: title,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pink Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 200, 107, 240),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 4),
      ),
      home: const HomePage(),
    );
  }
}

class DataWindowApp extends StatelessWidget {
  const DataWindowApp({
    super.key,
    required this.windowController,
    required this.dataType,
    required this.title,
  });

  final WindowController windowController;
  final String dataType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 235, 127, 208),
          brightness:
              Brightness.light, // Un tema claro para las ventanas de datos
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: DataWindowPage(dataType: dataType, title: title),
    );
  }
}
