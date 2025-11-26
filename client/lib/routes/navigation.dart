import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // VISTAS DEL DASHBOARD (Home, Perfil, etc.)
    final List<Widget> widgetOptions = <Widget>[
      Center(
        child: Text("Bienvenido ${authProvider.user?.nombre ?? 'Usuario'}"),
      ), // Home real
      Center(
        // Botón temporal de Logout para probar
        child: ElevatedButton(
          onPressed: () {
            authProvider.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text("Cerrar Sesión"),
        ),
      ),
    ];

    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ), // Usé Icon nativo por seguridad si falla el SVG
              label: 'Inicio',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
