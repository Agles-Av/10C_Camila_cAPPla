import 'dart:io';
import 'package:cappla/core/utils/street_alerts.dart';
import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/shared/widget/street_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // <--- IMPORTANTE

class PostFormScreen extends StatefulWidget {
  final PublicationModel? publication;

  const PostFormScreen({super.key, this.publication});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // VARIABLES DE UBICACIÓN
  double? _lat;
  double? _lng;
  bool _gettingLocation = false;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.publication != null) {
      _isEditing = true;
      _titleController.text = widget.publication!.titulo;
      _descController.text = widget.publication!.descripcion;
      // Cargar ubicación existente si es edición
      _lat = widget.publication!.latitud;
      _lng = widget.publication!.longitud;
    }
  }

  // --- LÓGICA PARA OBTENER GPS ---
  Future<void> _getCurrentLocation() async {
    setState(() => _gettingLocation = true);

    try {
      // 1. Verificar servicios de ubicación
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Los servicios de ubicación están desactivados.';
      }

      // 2. Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permisos de ubicación denegados.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permisos denegados permanentemente. Habilítalos en ajustes.';
      }

      // 3. Obtener posición actual
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });

      StreetAlerts.show(
        context,
        "Ubicación obtenida correctamente",
        AlertType.success,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _gettingLocation = false);
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

   if (!_isEditing && _selectedImages.isEmpty) {
  StreetAlerts.show(context, "Debes subir al menos una foto", AlertType.error);
  return;
}

if (_lat == null || _lng == null) {
  StreetAlerts.show(context, "Falta la ubicación del grafiti", AlertType.info);
  return;
}

    final homeProvider = context.read<HomeProvider>();
    final user = context.read<AuthProvider>().user;

    if (user == null) return;

    bool success;
    if (_isEditing) {
      success = await homeProvider.updatePost(
        widget.publication!.id,
        _titleController.text,
        _descController.text,
        _lat!, // Usamos la variable real
        _lng!, // Usamos la variable real
        user.id,
        _selectedImages,
      );
    } else {
      success = await homeProvider.createPost(
        _titleController.text,
        _descController.text,
        _lat!,
        _lng!,
        user.id,
        _selectedImages,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
      StreetAlerts.show(
        context,
        _isEditing
            ? "Publicación actualizada correctamente"
            : "Grafiti publicado con éxito",
        AlertType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Publicación" : "Nuevo Grafiti"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Ingresa un título" : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Ingresa una descripción" : null,
              ),
              const SizedBox(height: 20),

              // --- SECCIÓN DE UBICACIÓN (NUEVO) ---
              const Text(
                "Ubicación",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _lat != null ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _lat != null
                            ? "Lat: ${_lat!.toStringAsFixed(4)}, Lng: ${_lng!.toStringAsFixed(4)}"
                            : "No has agregado la ubicación",
                        style: TextStyle(
                          color: _lat != null ? kNeonPink : Colors.grey,
                          fontWeight: _lat != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (_gettingLocation)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      TextButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(Icons.my_location),
                        label: const Text("Obtener"),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ------------------------------------
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text("Seleccionar Fotos"),
              ),

              // ... (El resto del código de imágenes sigue igual)
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._selectedImages.map(
                      (file) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              File(file.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () => setState(
                                  () => _selectedImages.remove(file),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isEditing && _selectedImages.isEmpty)
                      ...widget.publication!.imagenes.map(
                        (img) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            img.url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: context.watch<HomeProvider>().isLoading
                      ? null
                      : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: context.watch<HomeProvider>().isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isEditing ? "Actualizar" : "Publicar",
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
