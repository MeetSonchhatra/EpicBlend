import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:lindi/lindi.dart';
import 'package:photo_editor/lindi/image_viewholder.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({Key? key}) : super(key: key);

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;

  bool showSlider = false;
  String activeAdjustment = "";

  late ColorFilterGenerator adj;
  late ImageViewHolder imageViewHolder;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    imageViewHolder = LindiInjector.get<ImageViewHolder>();
    adjust();
    super.initState();
  }

  adjust({b, c, s, h, se}) {
    adj = ColorFilterGenerator(name: 'Adjust', filters: [
      ColorFilterAddons.brightness(b ?? brightness),
      ColorFilterAddons.contrast(c ?? contrast),
      ColorFilterAddons.saturation(s ?? saturation),
      ColorFilterAddons.hue(h ?? hue),
      ColorFilterAddons.sepia(se ?? sepia),
    ]);
  }

  void applyAutoAdjust() {
    setState(() {
      brightness = 0.2;
      contrast = 0.3;
      saturation = 0.3;
      hue = 0.1;
      adjust(b: brightness, c: contrast, s: saturation, h: hue);
    });
  }

  void resetAdjustment() {
    setState(() {
      switch (activeAdjustment) {
        case "Brightness":
          brightness = 0;
          break;
        case "Contrast":
          contrast = 0;
          break;
        case "Saturation":
          saturation = 0;
          break;
        case "Hue":
          hue = 0;
          break;
        case "Sepia":
          sepia = 0;
          break;
      }
      adjust();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Adjust'),
        actions: [
          IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                imageViewHolder.changeImage(bytes!);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Screenshot(
                controller: screenshotController,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(adj.matrix),
                  child: Image.memory(imageViewHolder.currentImage!),
                ),
              ),
            ),
          ),
          _buildBottomBar(),
          if (showSlider) _buildCustomSlider(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomBarItem(Icons.auto_fix_high, 'Auto', () => applyAutoAdjust()),
          _bottomBarItem(Icons.brightness_4, "Brightness",
              () => setActiveAdjustment("Brightness")),
          _bottomBarItem(Icons.contrast, "Contrast",
              () => setActiveAdjustment("Contrast")),
          _bottomBarItem(Icons.water_drop, "Saturation",
              () => setActiveAdjustment("Saturation")),
          _bottomBarItem(
              Icons.filter_tilt_shift, "Hue", () => setActiveAdjustment("Hue")),
          _bottomBarItem(Icons.motion_photos_on, "Sepia",
              () => setActiveAdjustment("Sepia")),
        ],
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(icon, color: Colors.white), onPressed: onTap),
        Text(title, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  void setActiveAdjustment(String adjustment) {
    setState(() {
      if (activeAdjustment == adjustment) {
        showSlider = !showSlider;
      } else {
        activeAdjustment = adjustment;
        showSlider = true;
      }
    });
  }

  Widget _buildCustomSlider() {
    double value = _getActiveValue();
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFF93000A), // Change active track color
              inactiveTrackColor: Colors.grey, // Change inactive track color
              thumbColor: Color(0xFFFFB4AB), // Change thumb color
              overlayColor:
                  Colors.blue.withOpacity(0.2), // Change overlay color
              thumbShape: CustomThumbShape(),
            ),
            child: Slider(
              value: value,
              min: -1,
              max: 1,
              onChanged: (newValue) {
                setState(() {
                  _setActiveValue(newValue);
                  adjust();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '$activeAdjustment ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: resetAdjustment,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getActiveValue() {
    switch (activeAdjustment) {
      case "Brightness":
        return brightness;
      case "Contrast":
        return contrast;
      case "Saturation":
        return saturation;
      case "Hue":
        return hue;
      case "Sepia":
        return sepia;
      default:
        return 0;
    }
  }

  void _setActiveValue(double value) {
    switch (activeAdjustment) {
      case "Brightness":
        brightness = value;
        break;
      case "Contrast":
        contrast = value;
        break;
      case "Saturation":
        saturation = value;
        break;
      case "Hue":
        hue = value;
        break;
      case "Sepia":
        sepia = value;
        break;
    }
  }
}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(25, 25);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 15, paint);

    final textSpan = TextSpan(
      text: value.toStringAsFixed(2),
      style: TextStyle(color: Colors.white, fontSize: 12),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, 20));
  }
}
