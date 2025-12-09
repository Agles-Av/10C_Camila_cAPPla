import 'package:cappla/core/utils/map_style.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/shared/widget/street_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Posición inicial (CDMX Zócalo por defecto)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.4326, -99.1332),
    zoom: 12,
  );

  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para escuchar cambios específicos
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        // LÓGICA DE CÁMARA: Si hay una seleccionada, movemos el mapa
        if (provider.selectedPublication != null && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(
                provider.selectedPublication!.latitud,
                provider.selectedPublication!.longitud,
              ),
              15, // Zoom más cercano al seleccionar
            ),
          );
        }

        final Set<Marker> markers = provider.publications.map((pub) {
          return Marker(
            markerId: MarkerId(pub.id.toString()),
            position: LatLng(pub.latitud, pub.longitud),
            // Al tocar el marcador, lo seleccionamos
            onTap: () {
              provider.selectPublication(pub);
            },
          );
        }).toSet();

        return Scaffold(
          body: Stack(
            children: [
              // 1. EL MAPA (Fondo)
              GoogleMap(
                initialCameraPosition: _initialPosition,
                markers: markers,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                // Si tocan el mapa (fuera de un marker), deseleccionamos
                onTap: (_) => provider.selectPublication(null),
                onMapCreated: (controller) {
                  _mapController = controller;
                  controller.setMapStyle(darkMapStyle);
                  // Si al abrir el mapa ya había algo seleccionado (venimos del feed), movemos cámara
                  if (provider.selectedPublication != null) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(
                          provider.selectedPublication!.latitud,
                          provider.selectedPublication!.longitud,
                        ),
                        15,
                      ),
                    );
                  }
                },
              ),

              // 2. LA TARJETA FLOTANTE (Frente)
              if (provider.selectedPublication != null)
                Positioned(
                  bottom: 200, // Espacio para el BottomNavigationBar
                  left: 50,
                  right: 50,
                  child: _buildFloatingCard(provider.selectedPublication!),
                ),
            ],
          ),
        );
      },
    );
  }

  // Widget pequeño reutilizando estilos
  Widget _buildFloatingCard(PublicationModel pub) {
    return Card(
      color: Color(Color.fromARGB(255, 2, 56, 31).value),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Miniatura de imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: pub.imagenes.isNotEmpty
                    ? Image.network(pub.imagenes[0].url, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey,
                        child: const Icon(Icons.image),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pub.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Por: ${pub.user.nombre}",
                    style: const TextStyle(color: kNeonPink),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    pub.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            // Botón cerrar (opcional)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                // Deseleccionar usando el context del padre
                context.read<HomeProvider>().selectPublication(null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
