import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/shared/providers/navigation_provider.dart';
import 'package:cappla/features/shared/widget/carrusel_widgets.dart';
import 'package:cappla/features/shared/widget/street_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadPublications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final currentUser = context.read<AuthProvider>().user;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Grafitis Recientes")),
      body: ListView.builder(
        itemCount: provider.publications.length,
        itemBuilder: (context, index) {
          final pub = provider.publications[index];
          final int likesCount = pub.likes.length;

          final bool isLikedByMe =
              currentUser != null &&
              pub.likes.any((like) => like.user.id == currentUser.id);
        return StreetCard(
  // Pinta el borde rosa si le di like, o verde si es mío (opcional)
  borderColor: isLikedByMe ? kNeonPink : Colors.black, 
  
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // HEADER
      Row(
        children: [
          CircleAvatar(
             backgroundColor: kNeonGreen,
             child: Text(pub.user.nombre[0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Text(pub.user.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      const SizedBox(height: 10),

      // IMAGEN (Con borde negro fino)
      StreetCarousel(images: pub.imagenes),

      // ACCIONES
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                isLikedByMe ? Icons.favorite : Icons.favorite_border,
                // Si no es like, usamos blanco (o gris claro), si es like usamos el Rosa Neón
                color: isLikedByMe ? kNeonPink : Colors.white,
              ),
              onPressed: () {
                if (currentUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Debes iniciar sesión")),
                  );
                  return;
                }
                context.read<HomeProvider>().toggleLike(pub.id, currentUser);
              },
            )
            .animate(target: isLikedByMe ? 1 : 0) // El controlador
            .scale(
              // CORRECCIÓN AQUÍ:
              begin: const Offset(1.0, 1.0), // Estado 0: Tamaño normal (Visible)
              end: const Offset(1.3, 1.3),   // Estado 1: Un poco más grande (Efecto "Pump")
              duration: 200.ms,
              curve: Curves.elasticOut,
            )
            .tint( // Opcional: Un efecto extra de color
              color: kNeonPink, 
              end: 0.0, // Solo tiñe durante la transición
            ),
            
            Text("${pub.likes.length}", style: GoogleFonts.anton(fontSize: 18)),
            
            const Spacer(),
            
            // Botón de mapa estilo "Tag"
            InkWell(
              onTap: () { 
                // 1. Seleccionamos la publicación en el estado global
                      context.read<HomeProvider>().selectPublication(pub);
                      // 2. Cambiamos a la pestaña del mapa (índice 1)
                      context.read<NavigationProvider>().setIndex(1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.black,
                child: const Row(
                  children: [
                    Icon(Icons.map, color: kNeonGreen, size: 16),
                    SizedBox(width: 5),
                    Text("VER UBICACIÓN EN EL MAPA", style: TextStyle(color: kNeonGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      
      // TEXTOS
      Text(pub.titulo.toUpperCase(), style: GoogleFonts.anton(fontSize: 20, letterSpacing: 0.5)),
      Text(pub.descripcion, style: const TextStyle(color: Colors.grey)),
    ],
  ),
).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
        },
      ),
    );
  }
}
