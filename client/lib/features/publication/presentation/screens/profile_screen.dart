import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/publication/presentation/screens/post_form_screen.dart';
import 'package:cappla/features/shared/widget/street_widgets.dart'; // Asegúrate de tener esto importado
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // --- MODAL TUNEADO (ESTILO NEUBRUTALISMO) ---
  void _showPostOptions(BuildContext context, PublicationModel pub) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Hacemos transparente para dibujar nuestro propio cuadro
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kAsphalt, // Fondo oscuro
          border: Border.all(color: kNeonGreen, width: 2), // Borde Neón
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))], // Sombra dura
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Opción Editar
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: Text("EDITAR GRAFITI", style: GoogleFonts.anton(letterSpacing: 1, color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PostFormScreen(publication: pub)),
                  );
                },
              ),
              const Divider(color: Colors.grey, height: 1),
              // Opción Eliminar
              ListTile(
                leading: const Icon(Icons.delete, color: kNeonPink),
                title: Text("ELIMINAR", style: GoogleFonts.anton(letterSpacing: 1, color: kNeonPink)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context, pub.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- DIÁLOGO DE ALERTA TUNEADO ---
  void _confirmDelete(BuildContext context, int pubId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kConcrete,
        shape: const BeveledRectangleBorder(side: BorderSide(color: kNeonPink, width: 2)), // Borde rojo y cuadrado
        title: Text("¿BORRAR GRAFITI?", style: GoogleFonts.anton(color: Colors.white)),
        content: const Text(
          "Esta acción no se puede deshacer. Se perderá para siempre.",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCELAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kNeonPink,
              shape: const BeveledRectangleBorder(), // Botón cuadrado
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final user = context.read<AuthProvider>().user;
              if (user != null) {
                await context.read<HomeProvider>().deletePost(pubId, user.id);
              }
            },
            child: Text("ELIMINAR", style: GoogleFonts.anton(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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

    final homeProvider = context.watch<HomeProvider>();
    final myPosts = homeProvider.myPublications;
    final isLoading = homeProvider.isLoadingProfile;
    final totalLikes = homeProvider.getTotalLikesFromProfile();

    if (currentUser == null) return const Center(child: Text("Sin sesión"));

    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.nombre.toUpperCase()), // Nombre en mayúsculas se ve más rudo
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kNeonPink),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kNeonGreen))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // --- AVATAR CON BORDE NEÓN ---
                  Container(
                    padding: const EdgeInsets.all(3), // Espacio para el borde
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kNeonGreen, width: 2), // Borde verde neón
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: kConcrete,
                      backgroundImage: currentUser.foto != null
                          ? NetworkImage(currentUser.foto!)
                          : null,
                      child: currentUser.foto == null
                          ? Text(
                              currentUser.nombre[0].toUpperCase(),
                              style: GoogleFonts.anton(fontSize: 60, color: Colors.white),
                            )
                          : null,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                 
                  Text(
                    currentUser.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  
                  const SizedBox(height: 30),

                  // --- ESTADÍSTICAS TUNEADAS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("POSTS", myPosts.length.toString()),
                      Container(width: 1, height: 40, color: Colors.grey), // Separador vertical
                      _buildStatItem("LIKES", totalLikes.toString()),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // SEPARADOR ESTILO CALLE
                  const Divider(color: kNeonGreen, thickness: 2, indent: 20, endIndent: 20),

                  // --- GRID ---
                  if (myPosts.isEmpty)
                     Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text("AÚN NO HAY ARTE", style: GoogleFonts.anton(color: Colors.grey, fontSize: 18)),
                        ],
                      ),
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
                              color: kConcrete,
                              // Borde negro fino para separar las fotos
                              border: Border.all(color: Colors.black, width: 1), 
                            ),
                            child: pub.imagenes.isNotEmpty
                                ? Image.network(
                                    pub.imagenes[0].url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                                  )
                                : const Center(child: Icon(Icons.image_not_supported)),
                          ),
                        );
                      },
                    ),
                  
                  // Espacio final para que no tape el FAB ni el NavBar
                  const SizedBox(height: 120),
                ],
              ),
            ),
            
      // BOTÓN FLOTANTE TUNEADO
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: kNeonGreen, width: 2),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostFormScreen()),
            );
          },
          elevation: 10,
          child: const Icon(Icons.add, color: kNeonGreen, size: 30),
        ),
      ),
    );
  }

  // WIDGET DE ESTADÍSTICAS REUTILIZABLE
  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.anton(fontSize: 30, color: Colors.white), // Número gigante
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(color: kNeonGreen, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}