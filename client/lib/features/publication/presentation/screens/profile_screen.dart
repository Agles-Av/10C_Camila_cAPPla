import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/publication/presentation/screens/post_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _showPostOptions(BuildContext context, PublicationModel pub) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Editar Publicación"),
              onTap: () {
                Navigator.pop(ctx); // Cierra el modal
                // Navega al formulario en modo EDITAR
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PostFormScreen(publication: pub)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Eliminar Publicación"),
              onTap: () {
                Navigator.pop(ctx); // Cierra el modal
                _confirmDelete(context, pub.id);
              },
            ),
          ],
        ),
      ),
    );
}

void _confirmDelete(BuildContext context, int pubId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Eliminar?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final user = context.read<AuthProvider>().user;
              if (user != null) {
                await context.read<HomeProvider>().deletePost(pubId, user.id);
              }
            }, 
            child: const Text("Eliminar", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
}

  @override
  void initState() {
    super.initState();
    // 1. CARGAR DATOS AL INICIAR
    // Usamos addPostFrameCallback para hacerlo después de que se dibuje el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<HomeProvider>().loadMyPublications(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.user;

    // 2. LEER DATOS ESPECÍFICOS DEL PERFIL
    final homeProvider = context.watch<HomeProvider>();
    final myPosts = homeProvider.myPublications; // Usamos la nueva lista
    final isLoading = homeProvider.isLoadingProfile; // Usamos el loading nuevo
    final totalLikes = homeProvider.getTotalLikesFromProfile();

    if (currentUser == null) return const Center(child: Text("Sin sesión"));

    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator()) // Loading bonito
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // ... (El código de la foto y nombre es IGUAL que antes)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: currentUser.foto != null 
                        ? NetworkImage(currentUser.foto!) 
                        : null,
                    child: currentUser.foto == null
                        ? Text(currentUser.nombre[0].toUpperCase(), style: const TextStyle(fontSize: 40))
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(currentUser.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(currentUser.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  // --- ESTADÍSTICAS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("Publicaciones", myPosts.length.toString()),
                      _buildStatItem("Likes Recibidos", totalLikes.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),

                  // --- GRID ---
                  if (myPosts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text("Aún no tienes publicaciones"),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myPosts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
  final pub = myPosts[index];
  return GestureDetector(
    onTap: () => _showPostOptions(context, pub),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Fondo gris por si no carga
        border: Border.all(color: Colors.white, width: 1), // Separador blanco
      ),
      child: pub.imagenes.isNotEmpty
          ? Image.network(
              pub.imagenes[0].url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                  const Center(child: Icon(Icons.broken_image)),
            )
          : const Center(child: Icon(Icons.image_not_supported)),
    ),
  );
},
                      
                    ),
                ],
              ),
            ),
          // BOTÓN PARA CREAR NUEVO POST (Preparación para el siguiente paso)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // TODO: Navegar a pantalla de crear post
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostFormScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}











