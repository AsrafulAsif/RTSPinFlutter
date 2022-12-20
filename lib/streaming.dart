import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  bool _isplay = true;
  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
    "xxxxxxxxxxxxxxxxxxxx",
    hwAcc: HwAcc.full,
    autoPlay: true,
    // options: VlcPlayerOptions(),
  );
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(alignment: Alignment.bottomCenter, children: [
          InteractiveViewer(
            child: Center(
              child: InkWell(
                onTap: () {
                  if (_isplay) {
                    setState(() {
                      _isplay = false;
                    });
                    _vlcViewController.pause();
                  } else {
                    setState(() {
                      _isplay = true;
                    });
                    _vlcViewController.play();
                  }
                },
                child: VlcPlayer(
                  controller: _vlcViewController,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(child: CircularProgressIndicator()),
                  virtualDisplay: true,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: InkWell(
                onTap: () {
                  log('tap');
                  if (_isplay) {
                    setState(() {
                      _isplay = false;
                    });
                    _vlcViewController.pause();
                  } else {
                    setState(() {
                      _isplay = true;
                    });
                    _vlcViewController.play();
                  }
                },
                child: SizedBox(
                  child: _isplay
                      ? const Icon(
                          Icons.pause,
                          color: Colors.green,
                          size: 50,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          color: Colors.red,
                          size: 50,
                        ),
                ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                log('tap');
                final image = await _vlcViewController.takeSnapshot();
                await saveImage(image);
              },
              child: const Icon(
                Icons.screenshot_outlined,
                color: Colors.green,
                size: 40,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

saveImage(Uint8List image) async {
  await [Permission.storage].request();
  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '_')
      .replaceAll(':', '-');
  final name = 'screenshot_$time';
  final result = await ImageGallerySaver.saveImage(image, name: name);
  return result['filePath'];
}
