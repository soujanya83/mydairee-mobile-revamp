import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydiaree/core/config/app_asset.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:image_painter/image_painter.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
// import 'package:mykronicle_mobile/services/constants.dart';
// import 'package:mykronicle_mobile/utils/header.dart';
import 'package:open_file/open_file.dart';
// import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class SignaturePage extends StatefulWidget {
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  SignatureController controller = SignatureController();

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.white,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: Signature(
                controller: controller,
                backgroundColor: Colors.black,
              ),
            ),
            buildButtons(context),
            buildSwapOrientation(),
          ],
        ),
      );

  Widget buildSwapOrientation() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final newOrientation =
            isPortrait ? Orientation.landscape : Orientation.portrait;

        controller.clear();
        setOrientation(newOrientation);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPortrait
                  ? Icons.screen_lock_portrait
                  : Icons.screen_lock_landscape,
              size: 40,
            ),
            const SizedBox(width: 12),
            Text(
              'Tap to change signature orientation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCheck(context),
            buildClear(),
          ],
        ),
      );

  Widget buildCheck(BuildContext context) => IconButton(
        iconSize: 36,
        icon: Icon(Icons.check, color: Colors.green),
        onPressed: () async {
          if (controller.isNotEmpty) {
            final signature = await exportSignature();

            Navigator.pop(context, signature);
            // await Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => SignaturePreviewPage(signature: signature),
            // ));

            controller.clear();
          }
        },
      );

  Widget buildClear() => IconButton(
        iconSize: 36,
        icon: Icon(Icons.clear, color: Colors.red),
        onPressed: () => controller.clear(),
      );

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }

  void setOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}

class CustomDatePicker extends StatelessWidget {
  final String title;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final date =
                await _selectDate(context, selectedDate ?? DateTime.now());
            if (date != null) onDateSelected(date);
          },
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            elevation: 1,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      selectedDate != null
                          ? DateFormat("dd-MM-yyyy").format(selectedDate!)
                          : 'Select Date',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today,
                        color: AppColors.primaryColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTimePicker extends StatelessWidget {
  final String title;
  final String? selectedHour;
  final String? selectedMinute;
  final List<String>? hours;
  final List<String>? minutes;
  final Function(String?) onHourChanged;
  final Function(String?) onMinuteChanged;

  const CustomTimePicker({
    super.key,
    required this.title,
    required this.selectedHour,
    required this.selectedMinute,
    required this.hours,
    required this.minutes,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: CustomDropdown<String>(
                height: 45,
                value: selectedHour,
                items: hours ?? [],
                onChanged: onHourChanged,
                hint: 'Hour',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomDropdown<String>(
                height: 45,
                value: selectedMinute,
                items: minutes ?? [],
                onChanged: onMinuteChanged,
                hint: 'Minute',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomSignatureField extends StatelessWidget {
  final String title;
  final Uint8List? signature;
  final VoidCallback onTap;

  const CustomSignatureField({
    super.key,
    required this.title,
    required this.signature,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            child: Container(
              height: signature != null ? 100 : 45,
              width: signature != null ? 150 : double.infinity,
              decoration: BoxDecoration(
                color: signature != null
                    ? AppColors.grey.withOpacity(0.1)
                    : AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: signature != null
                  ? Image.memory(signature!, height: 45, fit: BoxFit.contain)
                  : const Center(child: Text('Tap to add signature')),
            ),
          ),
        ),
      ],
    );
  }
}

class AccidentImage extends StatefulWidget {
  @override
  _AccidentImageState createState() => _AccidentImageState();
}

class _AccidentImageState extends State<AccidentImage> {
  final _imageKey = GlobalKey<ImagePainterState>();
  late ImagePainterController _controller; // ✅ Add controller

  @override
  void initState() {
    super.initState();
    _controller = ImagePainterController(
      // ✅ Set properties in controller
      mode: PaintMode.line, // Equivalent to initialPaintMode
      strokeWidth: 2, // Equivalent to initialStrokeWidth
      color: Colors.green, // Equivalent to initialColor
    );
  }

  void saveImage() async {
    final image = await _controller.exportImage();
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to export image")),
      );
      return;
    }

    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath =
        '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File(fullPath);

    await imgFile.writeAsBytes(image);

    final imgfilefinal = base64Encode(await imgFile.readAsBytes());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.only(left: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Image Exported successfully.",
                style: TextStyle(color: Colors.white)),
            TextButton(
                onPressed: () => OpenFile.open(fullPath),
                child: Text("Open", style: TextStyle(color: Colors.blue[200]))),
          ],
        ),
      ),
    );

    Navigator.pop(context, imgfilefinal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(actions: [
          IconButton(onPressed: saveImage, icon: Icon(Icons.save))
        ]),
        body: ImagePainter.asset(
          AppAssets.accident,
          key: _imageKey,
          controller: _controller, // ✅ Pass the updated controller
          scalable: true, // Optional: Allows zooming & panning
          showControls: true, // Optional: Displays UI controls for painting
        ));
  }
}
