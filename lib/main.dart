import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/service_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VehicleProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestão de Veículos',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
