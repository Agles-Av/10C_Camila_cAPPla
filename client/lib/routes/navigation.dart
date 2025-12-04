import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/publication/presentation/screens/home_screen.dart';
import 'package:cappla/features/publication/presentation/screens/map_screen.dart';
import 'package:cappla/features/publication/presentation/screens/profile_screen.dart';
import 'package:cappla/features/shared/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Cambiamos a StatelessWidget. Ya no necesitamos estado local.
class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Escuchamos el provider. Esta es nuestra única fuente de verdad.
    final navProvider = context.watch<NavigationProvider>();
    final currentIndex = navProvider.currentIndex;

    final List<Widget> widgetOptions = <Widget>[
      const HomeScreen(), // Tab 0
      const MapScreen(), // Tab 1
      const ProfileScreen(),
    ];

    return Scaffold(
      // 3. Usamos el índice del Provider para elegir la pantalla
      body: widgetOptions.elementAt(currentIndex),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
          // 4. Usamos el índice del Provider para pintar el botón activo
          currentIndex: currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,

          // 5. Al tocar, actualizamos el Provider
          onTap: (index) => navProvider.setIndex(index),
        ),
      ),
    );
  }
}
