// ... imports (material, google_fonts, etc)

import 'package:cappla/features/shared/widget/street_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreetCarousel extends StatefulWidget {
  final List<dynamic> images; // Aceptamos lista dinámica (ImageModel)
  final double height;

  const StreetCarousel({
    super.key,
    required this.images,
    this.height = 300,
  });

  @override
  State<StreetCarousel> createState() => _StreetCarouselState();
}

class _StreetCarouselState extends State<StreetCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Si no hay imágenes, mostramos caja gris
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: Colors.grey[800],
        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.white)),
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black, width: 2), // Borde rudo
      ),
      child: Stack(
        children: [
          // 1. EL DESLIZADOR (PageView)
          PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index].url,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: kNeonGreen,
                    ),
                  );
                },
                errorBuilder: (ctx, error, stackTrace) => 
                    const Center(child: Icon(Icons.broken_image, color: kNeonPink, size: 50)),
              );
            },
          ),

          // 2. INDICADOR ESTILO "TAG" (Solo si hay más de 1 foto)
          if (widget.images.length > 1)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.black, // Fondo negro
                  // Sombra dura verde neón para resaltar
                  boxShadow: [BoxShadow(color: kNeonGreen, offset: Offset(2, 2))],
                ),
                child: Text(
                  "${_currentPage + 1} / ${widget.images.length}",
                  style: GoogleFonts.anton(
                    color: kNeonGreen, 
                    fontSize: 14,
                    letterSpacing: 1
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}