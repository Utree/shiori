import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shiori_client/ui/component/AppTheme.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContent extends StatefulWidget {
  @override
  _AddContent createState() => _AddContent();
}

class _AddContent extends State<AddContent> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  VideoPlayerController _toBeDisposed;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(PickedFile file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      if (kIsWeb) {
        _controller = VideoPlayerController.network(file.path);
        // In web, most browsers won't honor a programmatic call to .play
        // if the video has a sound track (and is not muted).
        // Mute the video so it auto-plays in web!
        // This is not needed if the call to .play is the result of user
        // interaction (clicking on a "play" button, for example).
        await _controller.setVolume(0.0);
      } else {
        _controller = VideoPlayerController.file(File(file.path));
        await _controller.setVolume(1.0);
      }
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }

    // パーミッションを取得
    // flutterのバージョンに注意
    // https://github.com/flutter/flutter/issues/64764
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;
    if(cameraStatus.isGranted && storageStatus.isGranted) {
      if (isVideo) {
        final PickedFile file = await _picker.getVideo(
            source: source, maxDuration: const Duration(seconds: 10));
        await _playVideo(file);
      } else {
        try {
          final pickedFile = await _picker.getImage(source: source);
          setState(() {
            _imageFile = pickedFile;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile.path);
      } else {
        return Image.file(File(_imageFile.path));
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }
  // stepperの進捗
  int _currentStep = 0;
  // 紐付けるコンテンツ
  var _sptVal = "abc空港";
  var _ctsVal = "写真を取る";

  void _onChangedSpt(String value) {
    setState(() {
      _sptVal = value;
    });
  }
  void _onChangedCts(String value) {
    setState(() {
      _ctsVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      appBar: AppBar(title: Text("コンテンツを追加"),backgroundColor: AppTheme.orange,),
      body: Theme(
        data: ThemeData(
            accentColor: Colors.orange,
            primarySwatch: Colors.orange,
            colorScheme: ColorScheme.light(
                primary: Colors.orange
            )
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepTapped: (int step) => setState(() => _currentStep = step),
          onStepContinue: () {
            setState(() {
              if(_currentStep < 2) {
                _currentStep += 1;
                if(_currentStep == 2) {
                  switch(_ctsVal) {
                    case "写真を取る":
                      isVideo = false;
                      _onImageButtonPressed(ImageSource.camera, context: context);
                      break;
                    case "写真を選択":
                      isVideo = false;
                      _onImageButtonPressed(ImageSource.gallery, context: context);
                      break;
                    case "動画を撮る":
                      isVideo = true;
                      _onImageButtonPressed(ImageSource.camera);
                      break;
                    case "動画を選択":
                      isVideo = true;
                      _onImageButtonPressed(ImageSource.gallery);
                      break;
                    default:
                      // TODO: 文章を書くの処理
                      break;
                  }
                }
              } else if(_currentStep == 2) {
                Navigator.pop(context);
              }
            });
          },
          onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
          steps: <Step>[
            new Step(
              title: new Text('スポット'),
              content: Column(
                children: <Widget>[
                  Row(children: <Widget>[Text("紐付けるスポットを選択してください", textAlign: TextAlign.left,)],),
                  Column(
                    children: <Widget>[
                      RadioListTile(
                          title: Text('abc空港'),
                          value: 'abc空港',
                          groupValue: _sptVal,
                          onChanged: _onChangedSpt),
                      RadioListTile(
                          title: Text('def道の駅'),
                          value: 'def道の駅',
                          groupValue: _sptVal,
                          onChanged: _onChangedSpt),
                      RadioListTile(
                          title: Text('ghiホテル'),
                          value: 'ghiホテル',
                          groupValue: _sptVal,
                          onChanged: _onChangedSpt),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            new Step(
              title: new Text('コンテンツ'),
              content: Column(
                children: <Widget>[
                  Row(children: <Widget>[Text("紐付けるコンテンツを選択してください", textAlign: TextAlign.left,)],),
                  Column(
                    children: <Widget>[
                      RadioListTile(
                          title: Text('写真を取る'),
                          value: '写真を取る',
                          groupValue: _ctsVal,
                          onChanged: _onChangedCts),
                      RadioListTile(
                          title: Text('写真を選択'),
                          value: '写真を選択',
                          groupValue: _ctsVal,
                          onChanged: _onChangedCts),
                      RadioListTile(
                          title: Text('動画を撮る'),
                          value: '動画を撮る',
                          groupValue: _ctsVal,
                          onChanged: _onChangedCts),
                      RadioListTile(
                          title: Text('動画を選択'),
                          value: '動画を選択',
                          groupValue: _ctsVal,
                          onChanged: _onChangedCts),
                      RadioListTile(
                          title: Text('文章を書く'),
                          value: '文章を書く',
                          groupValue: _ctsVal,
                          onChanged: _onChangedCts),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            new Step(
              title: new Text('確認'),
              content: Center(
                child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                    ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return isVideo ? _previewVideo() : _previewImage();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
                    : (isVideo ? _previewVideo() : _previewImage()),
              ),
              isActive: _currentStep >= 0,
              state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      )
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}
