import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/shared/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
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
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER DEL USUARIO ---
                ListTile(
                  leading: CircleAvatar(
                    child: Text(pub.user.nombre[0].toUpperCase()),
                  ),
                  title: Text(
                    pub.user.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Opcional: poner fecha o ubicación pequeña aquí
                ),

                // --- IMAGEN ---
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: pub.imagenes.isNotEmpty
                      ? PageView.builder(
                          itemCount: pub.imagenes.length,
                          itemBuilder: (ctx, imgIndex) {
                            return Image.network(
                              pub.imagenes[imgIndex].url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(child: Text("Sin imagen")),
                        ),
                ),

                // --- ACCIONES (LIKES) ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLikedByMe ? Icons.favorite : Icons.favorite_border,
                          color: isLikedByMe ? Colors.red : Colors.black87,
                          size: 28,
                        ),
                        onPressed: () {
                          if (currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Debes iniciar sesión"),
                              ),
                            );
                            return;
                          }

                          // LLAMADA AL PROVIDER
                          context.read<HomeProvider>().toggleLike(
                            pub.id,
                            currentUser,
                          );
                        },
                      ),
                      Text(
                        "$likesCount Me gusta",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // --- DESCRIPCIÓN ---
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pub.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(pub.descripcion),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: InkWell(
                    // Hacemos que sea tocable
                    onTap: () {
                      // 1. Seleccionamos la publicación en el estado global
                      context.read<HomeProvider>().selectPublication(pub);
                      // 2. Cambiamos a la pestaña del mapa (índice 1)
                      context.read<NavigationProvider>().setIndex(1);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Ver ubicación en mapa",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
