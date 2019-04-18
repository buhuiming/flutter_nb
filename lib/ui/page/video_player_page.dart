import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:video_player/video_player.dart';

/*
* 视频播放
*/
class VideoPlayerPage extends StatefulWidget {
  final String url;

  VideoPlayerPage(this.url, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoPlayerState();
  }
}

class VideoPlayerState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  bool _isShowPlay = false;
  bool _isShowLoading = true;
  VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      if (_controller.value.position.inMilliseconds >=
              _controller.value.duration.inMilliseconds &&
          !_isShowPlay) {
        setState(() {
          _isShowPlay = true;
        });
      } else if (_controller.value.position.inMilliseconds <
              _controller.value.duration.inMilliseconds &&
          _isShowPlay) {
        setState(() {
          _isShowPlay = false;
        });
      }
    };
    if (widget.url != null) {
      if (widget.url.startsWith('http')) {
        _controller = VideoPlayerController.network(widget.url)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {
              _controller.addListener(_listener);
              _isShowLoading = false;
              _controller.play();
            });
          });
      } else if (widget.url.contains('/storage/emulated/0')) {
        _controller = VideoPlayerController.file(File(widget.url))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {
              _controller.addListener(_listener);
              _isShowLoading = false;
              _controller.play();
            });
          });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_listener);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: 400,
            width: double.infinity,
            child: _controller.value.initialized
                ? Column(
                    children: <Widget>[
                      SizedBox(
                          height: 392,
                          width: double.infinity,
                          child: GestureDetector(
                              onTap: () {
                                _onTap();
                              },
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ))),
                      SizedBox(
                          height: 8,
                          width: double.infinity,
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                          ))
                    ],
                  )
                : Container(),
          ),
          _isShowPlay
              ? GestureDetector(
                  onTap: () {
                    _onTap();
                  },
                  child: Icon(
                    Icons.play_circle_outline,
                    color: ObjectUtil.getThemeSwatchColor(),
                    size: 50,
                  ))
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
          _isShowLoading
              ? SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        ObjectUtil.getThemeSwatchColor()),
                    strokeWidth: 3,
                  ))
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      )),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }

  _onTap() {
    setState(() {
      if (_controller.value.isPlaying) {
        if (_controller.value.position.inMilliseconds >=
            _controller.value.duration.inMilliseconds) {
          //bug:播放完成了，isPlaying还是true，
          _controller.seekTo(Duration(hours: 0, minutes: 0, seconds: 0));
          _controller.play();
          _isShowPlay = false;
        } else {
          _controller.pause();
          _isShowPlay = true;
        }
      } else {
        _controller.play();
        _isShowPlay = false;
      }
    });
  }
}
