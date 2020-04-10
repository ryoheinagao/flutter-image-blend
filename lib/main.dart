import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Blend Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // load png image
  Future<ui.Image> _loadPngImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return decodeImageFromList(byteData.buffer.asUint8List());
  }

  // load svg image
  Future<ui.Image> _loadSvgImage(String assetPath) async {
    final rawSvg = await rootBundle.loadString(assetPath);
    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    final Picture picture = svgRoot.toPicture();
    return picture.toImage(32, 32);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Blend Example'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Image.asset("assets/gear.png"),
              const Text(
                'Original Image',
                style: TextStyle(fontSize: 24),
              ),
              Container(
                height: 40.0,
                width: double.infinity,
              ),
              Image.asset(
                "assets/gear.png",
                color: Colors.green,
                colorBlendMode: BlendMode.srcIn,
              ),
              const Text(
                'Blend Color Image',
                style: TextStyle(fontSize: 24),
              ),
              Container(
                height: 40.0,
                width: double.infinity,
              ),
              FutureBuilder(
                  future: _loadPngImage("assets/star.png"),
                  builder: (context, AsyncSnapshot<ui.Image> image) {
                    return (image.hasData)
                        ? ShaderMask(
                            child: Image.asset("assets/gear.png"),
                            shaderCallback: (bounds) => ImageShader(
                              image.data,
                              TileMode.repeated,
                              TileMode.repeated,
                              Matrix4.identity().storage,
                            ),
                            blendMode: BlendMode.srcIn,
                          )
                        : Container();
                  }),
              const Text(
                'Blend Image And Image (png)',
                style: TextStyle(fontSize: 24),
              ),
              Container(
                height: 40.0,
                width: double.infinity,
              ),
              FutureBuilder(
                  future: _loadSvgImage("assets/star.svg"),
                  builder: (context, AsyncSnapshot<ui.Image> image) {
                    return (image.hasData)
                        ? ShaderMask(
                            child: Image.asset("assets/gear.png"),
                            shaderCallback: (bounds) => ImageShader(
                              image.data,
                              TileMode.repeated,
                              TileMode.repeated,
                              Matrix4.identity().storage,
                            ),
                            blendMode: BlendMode.srcIn,
                          )
                        : Container();
                  }),
              const Text(
                'Blend Image And Image (svg)',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
