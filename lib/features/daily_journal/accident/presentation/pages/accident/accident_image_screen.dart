// --- New file: accident_image_mark_screen.dart ---
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';

class AccidentImageMarkScreen extends StatefulWidget {
  final Uint8List? initialImage;
  const AccidentImageMarkScreen({Key? key, this.initialImage})
      : super(key: key);

  @override
  State<AccidentImageMarkScreen> createState() =>
      _AccidentImageMarkScreenState();
}

class _AccidentImageMarkScreenState extends State<AccidentImageMarkScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  late ImagePainterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ImagePainterController(
      mode: PaintMode.circle,
      strokeWidth: 3,
      color: Colors.red,
    );
  }

  Future<void> _saveMarkedImage() async {
    final image = await _controller.exportImage();
    if (image != null) {
      Navigator.pop(context, image);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to export image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can use a local asset or a network image as the base image
    // For demo, use a placeholder asset. Replace with your actual asset path.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Injury'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMarkedImage,
          ),
        ],
      ),
      body: ImagePainter.asset(
        'assets/images/accident.jpeg',
        key: _imageKey,
        controller: _controller,
        scalable: true,
        showControls: true,
      ),
    );
  }
}
