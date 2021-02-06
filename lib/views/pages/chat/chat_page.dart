import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flt_im_plugin/conversion.dart';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flt_im_plugin/value_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geen/views/pages/home/home_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_view.dart';
import 'package:flutter_geen/views/pages/chat/view/emoji/emoji_picker.dart';
import 'package:flutter_geen/views/pages/chat/view/util/ImMessage.dart';
import 'package:flutter_geen/views/pages/chat/widget/Swipers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/blocs/peer/peer_bloc.dart';
import 'package:flutter_geen/blocs/peer/peer_event.dart';
import 'package:flutter_geen/blocs/peer/peer_state.dart';
import 'package:flutter_geen/views/pages/chat/widget/more_widgets.dart';
import 'package:flutter_geen/views/pages/chat/widget/popupwindow_widget.dart';
import 'package:flutter_geen/views/pages/resource/colors.dart';
import 'package:flutter_geen/views/pages/utils/date_util.dart';
import 'package:flutter_geen/views/pages/utils/dialog_util.dart';
import 'package:flutter_geen/views/pages/utils/file_util.dart';
import 'package:flutter_geen/views/pages/utils/functions.dart';
import 'package:flutter_geen/views/pages/utils/image_util.dart';
import 'package:flutter_geen/views/pages/utils/object_util.dart';
import 'package:frefresh/frefresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as path;
/*
*  发送聊天信息
*/
class ChatsPage extends StatefulWidget {

  final Conversion model;
  final String memId ;
  ChatsPage({this.model,this.memId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatsState();
  }
}

class ChatsState extends State<ChatsPage> {
  bool _isBlackName = false;
  var _popString = List<String>();
  bool _isShowSend = false; //是否显示发送按钮
  bool _isShowVoice = false; //是否显示语音输入栏
  bool _isShowFace = false; //是否显示表情栏
  bool _isShowTools = false; //是否显示工具栏
  var voiceText = '按住 说话';
  var voiceBackground = ObjectUtil.getThemeLightColor();
  Color _headsetColor = ColorT.gray_99;
  Color _highlightColor = ColorT.gray_99;
  List<Widget> _guideFaceList = new List();
  List<Widget> _guideFigureList = new List();
  List<Widget> _guideToolsList = new List();
  bool _isFaceFirstList = true;
  bool _alive = false;
  String _audioIconPath = '';
  String _voiceFilePath = '';
  String tfSender="0" ;
  FltImPlugin im = FltImPlugin();
  FRefreshController controller3;
  bool _isLoading = false;
  Permission _permission;
  Timer _timer;
  int voiceCount = 0;
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  // StreamSubscription _dbPeakSubscription;
  FlutterSoundRecorder flutterSound;
  TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FocusNode _textFieldNode = FocusNode();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _alive = true;
    tfSender =widget.model.memId;
    controller3 = FRefreshController();
    _textFieldNode.addListener(_focusNodeListener); // 初始化一个listener
    _getLocalMessage();
    _initData();
    _checkBlackList();
    _getPermission();
    _scrollController.addListener(() {
      if (!mounted) {
        return;
      }
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {

        if (_isLoading) {
          return;
        }

        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        Future.delayed(Duration(milliseconds: 150), () {
          _onRefresh();
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    });
    init();
  }
  Future<void> _initializeExample(bool withUI) async {

    await playerModule.closeAudioSession();

    await playerModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);

    await playerModule.setSubscriptionDuration(Duration(milliseconds: 30));
    await recorderModule.setSubscriptionDuration(Duration(milliseconds: 30));
  }

  Future<void> init() async {
    recorderModule.openAudioSession(
        focus: AudioFocus.requestFocusTransient,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _initializeExample(false);

    if (Platform.isAndroid) {
      // copyAssets();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _alive = false;
    super.dispose();
    _textFieldNode.removeListener(_focusNodeListener); // 页面消失时必须取消这个listener！！
    _cancelRecorderSubscriptions();
    _cancelPlayerSubscriptions();
    _releaseFlauto();
  }
  /// 取消录音监听
  /// 结束录音
  _stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('stopRecorder');
      _cancelRecorderSubscriptions();
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  /// 取消录音监听
  void _cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  /// 取消播放监听
  void _cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  /// 释放录音和播放
  Future<void> _releaseFlauto() async {
    try {
      await playerModule.closeAudioSession();
      await recorderModule.closeAudioSession();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }

  Future<Null> _focusNodeListener() async {
    if (_textFieldNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 5), () {
        setState(() {
          _isShowTools = false;
          _isShowFace = false;
          _isShowVoice = false;
          try {
            if(mounted)
            _scrollController.position.jumpTo(0);
          } catch (e) {}
        });
      });
    }
  }
  _getPermission() {
    requestPermiss(_permission);
  }
  void requestPermiss(Permission permission) async {
    //多个权限申请
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.speech,
      Permission.microphone
    ].request();
    print(statuses);
  }
  _getLocalMessage() async {

  }

  _initData() {
    _popString.add('清空记录');
    _popString.add('删除好友');
    _popString.add('加入黑名单');
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     if (visible) {
    //       _isShowTools = false;
    //       _isShowFace = false;
    //       _isShowVoice = false;
    //       try {
    //         _scrollController.position.jumpTo(0);
    //       } catch (e) {}
    //     }
    //   },
    // );
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _onRefresh();
    //   }
    // });
  }

  _checkBlackList() {

  }

  _initFaceList() {
    if (_guideFaceList.length > 0) {
      _guideFaceList.clear();
    }
    if (_guideFigureList.length > 0) {
      _guideFigureList.clear();
    }
    //添加表情图
    List<String> _faceList = new List();
    String faceDeletePath =
        FileUtil.getImagePath('face_delete', dir: 'face', format: 'png');
    String facePath;
    for (int i = 0; i < 100; i++) {
      if (i < 90) {
        facePath =
            FileUtil.getImagePath(i.toString(), dir: 'face', format: 'gif');
      } else {
        facePath =
            FileUtil.getImagePath(i.toString(), dir: 'face', format: 'png');
      }
      _faceList.add(facePath);
      if (i == 19 || i == 39 || i == 59 || i == 79 || i == 99) {
        _faceList.add(faceDeletePath);
        _guideFaceList.add(_gridView(7, _faceList));
        _faceList.clear();
      }
    }
    //添加斗图
    List<String> _figureList = new List();
    for (int i = 0; i < 96; i++) {
      if (i == 70 || i == 74) {
        String facePath =
            FileUtil.getImagePath(i.toString(), dir: 'figure', format: 'png');
        _figureList.add(facePath);
      } else {
        String facePath =
            FileUtil.getImagePath(i.toString(), dir: 'figure', format: 'gif');
        _figureList.add(facePath);
      }
      if (i == 9 ||
          i == 19 ||
          i == 29 ||
          i == 39 ||
          i == 49 ||
          i == 59 ||
          i == 69 ||
          i == 79 ||
          i == 89 ||
          i == 95) {
        _guideFigureList.add(_gridView(5, _figureList));
        _figureList.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget widgets = MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        home: Scaffold(
          appBar: _appBar(),
          body: BlocListener<PeerBloc, PeerState>(
              listener: (ctx, state) {
                if (state is PeerMessageSuccess) {
                  //_scrollToBottom();
                  if(mounted)
                  _scrollController.position.jumpTo(0);
                }
              },
              child:BlocBuilder<PeerBloc, PeerState>(builder: (ctx, state) {
                return _body(ctx, state);
              })),
        ));
    return widgets;
  }

  _appBar() {
    return MoreWidgets.buildAppBar(
      context, widget.model.name,
      centerTitle: true,
      elevation: 0.0,
      leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        InkWell(
            child: Container(
                padding: EdgeInsets.only(right: 15.w, left: 15.w),
                child: Icon(
                  Icons.more_horiz,
                  size: 50.sp,
                  color: Colors.black,
                )),
            onTap: () {
              MoreWidgets.buildDefaultMessagePop(context, _popString,
                  onItemClick: (res) {
                switch (res) {
                  case 'one':
                    DialogUtil.showBaseDialog(context, '即将删除该对话的全部聊天记录',
                        right: '删除', left: '再想想', rightClick: (res) {
                      _deleteAll();
                    });
                    break;
                  case 'two':
                    DialogUtil.showBaseDialog(context, '确定删除好友吗？',
                        right: '删除', left: '再想想', rightClick: (res) {

                    });
                    break;
                  case 'three':
                    if (_isBlackName) {
                      DialogUtil.showBaseDialog(context, '确定把好友移出黑名单吗？',
                          right: '移出', left: '再想想', rightClick: (res) {

                      });
                    } else {
                      DialogUtil.showBaseDialog(context, '确定把好友加入黑名单吗？',
                          right: '赶紧', left: '再想想', rightClick: (res) {
                        DialogUtil.showBaseDialog(
                            context, '即将将好友加入黑名单，是否需要支持发消息给TA？',
                            right: '需要',
                            left: '不需要',
                            title: '', rightClick: (res) {

                        }, leftClick: (res) {

                        });
                      });
                    }
                    break;
                }
              });
            })
      ],
    );
  }

  Future _deleteAll() async {


  }

  _body(BuildContext context, PeerState peerState) {
    return Column(
        children: <Widget>[
      Flexible(
          child: InkWell(
        child: _messageListView(context, peerState),
        onTap: () {
          _hideKeyBoard();
          if(_isShowVoice == true ||_isShowFace == true||_isShowTools == true){
            setState(() {
              _isShowVoice = false;
              _isShowFace = false;
              _isShowTools = false;
            });
          }

        },
      )),
      Divider(height: 1.h),
      Container(
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Container(
          height: 88.h,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: _isShowVoice
                      ? Icon(Icons.keyboard)
                      : Icon(Icons.play_circle_outline),
                  iconSize: 55.sp,
                  onPressed: () {
                    setState(() {
                      _hideKeyBoard();
                      if (_isShowVoice) {
                        _isShowVoice = false;
                      } else {
                        _isShowVoice = true;
                        _isShowFace = false;
                        _isShowTools = false;
                      }
                    });
                  }),
              new Flexible(

                  child: _enterWidget()
              ),
              IconButton(
                  icon: _isShowFace
                      ? Icon(Icons.keyboard)
                      : Icon(Icons.sentiment_very_satisfied),
                  iconSize: 55.sp,
                  onPressed: () {
                    _hideKeyBoard();
                    setState(() {
                      if (_isShowFace) {
                        _isShowFace = false;
                      } else {
                        _isShowFace = true;
                        _isShowVoice = false;
                        _isShowTools = false;
                      }
                    });
                  }),
              _isShowSend
                  ? InkWell(
                      onTap: () {
                        if (_controller.text.isEmpty) {
                          return;
                        }
                        _buildTextMessage(_controller.text);
                      },
                      child: new Container(
                        alignment: Alignment.center,
                        width: 90.w,
                        height: 32.h,
                        margin: EdgeInsets.only(right: 8.w),
                        child: new Text(
                          '发送',
                          style: new TextStyle(
                              fontSize: 28.sp, color: Colors.red),
                        ),
                        decoration: new BoxDecoration(
                          color: ObjectUtil.getThemeSwatchColor(),
                          borderRadius: BorderRadius.all(Radius.circular(8.w)),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 55.sp,
                      onPressed: () {
                        _hideKeyBoard();
                        setState(() {
                          if (_isShowTools) {
                            _isShowTools = false;
                          } else {
                            _isShowTools = true;
                            _isShowFace = false;
                            _isShowVoice = false;
                          }
                        });
                      }),
            ],
          ),
        ),
      ),
      (_isShowTools || _isShowFace || _isShowVoice)
          ? Container(
              height: 418.h,
              child: _bottomWidget(),
            )
          : SizedBox(
              height: 0,
            )
    ]);
  }

  _hideKeyBoard() {
    _textFieldNode.unfocus();
  }

  _bottomWidget() {
    Widget widget;
    if (_isShowTools) {
      widget = _toolsWidget();
    } else if (_isShowFace) {
      widget = _faceWidget();
    } else if (_isShowVoice) {
      widget = _voiceWidget();
    }
    return widget;
  }

  _voiceWidget() {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.all(20.w),
                child: Icon(
                  Icons.headset,
                  color: _headsetColor,
                  size: 80.sp,
                ))),
        Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 10.h),
                        child: _audioIconPath == ''
                            ? SizedBox(
                                width: 60.w,
                                height: 60.h,
                              )
                            : Image.asset(
                                FileUtil.getImagePath(_audioIconPath,
                                    dir: 'icon', format: 'png'),
                                width: 60.w,
                                height: 60.h,
                                color: ObjectUtil.getThemeSwatchColor(),
                              )),

                            Text(voiceCount.toString() +"S")
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(10.w),
                    child: GestureDetector(
                      onScaleStart: (res) async {
                        if(_timer != null){
                          _timer.cancel();
                          _timer =Timer.periodic(
                              Duration(milliseconds: 1000), (t){
                            //print(voiceCount);
                            setState(() {
                              voiceCount= voiceCount+1;
                            });
                          }
                          );
                        }else{
                          _timer =Timer.periodic(
                              Duration(milliseconds: 1000), (t){
                            //print(voiceCount);
                            setState(() {
                              voiceCount= voiceCount+1;
                            });
                          }
                          );
                        }

                        if(recorderModule.isRecording ){
                          await _stopRecorder();
                        }
                        _startRecord();


                      },
                      onScaleEnd: (res) async {
                        if (_headsetColor == ObjectUtil.getThemeLightColor()) {
                          DialogUtil.buildToast('试听功能暂未实现');
                          if (recorderModule.isRecording) {
                            _stopRecorder();
                          }
                        } else if (_highlightColor ==
                            ObjectUtil.getThemeLightColor()) {
                          File file = File(_voiceFilePath);
                          file.delete();
                          if (recorderModule.isRecording) {
                            _stopRecorder();
                          }
                        } else {
                          if (recorderModule.isRecording) {
                              _stopRecorder();
                              var  length = await _getDuration(_voiceFilePath);
                              File file = File(_voiceFilePath);
                                if (length*1000 < 1000) {
                                  //小于1s不发送
                                  file.delete();
                                  DialogUtil.buildToast('你说话时间太短啦~');
                                } else {
                                  //发送语音
                                  _buildVoiceMessage(file, length.floor());
                                }
                                voiceCount= 0;
                                _timer.cancel();
                          }
                        }
                        setState(() {
                          _audioIconPath = '';
                          voiceText = '按住 说话';
                          voiceBackground = ObjectUtil.getThemeLightColor();
                          _headsetColor = ColorT.gray_99;
                          _highlightColor = ColorT.gray_99;
                        });
                      },
                      onScaleUpdate: (res) {
                        if (res.focalPoint.dy > 550.h &&
                            res.focalPoint.dy < 620.h) {
                          if (res.focalPoint.dx > 10.w &&
                              res.focalPoint.dx < 80.w) {
                            setState(() {
                              voiceText = '松开 试听';
                              _headsetColor = ObjectUtil.getThemeLightColor();
                            });
                          } else if (res.focalPoint.dx > 330.w &&
                              res.focalPoint.dx < 400.w) {
                            setState(() {
                              voiceText = '松开 删除';
                              _highlightColor = ObjectUtil.getThemeLightColor();
                            });
                          } else {
                            setState(() {
                              voiceText = '松开 结束';
                              _headsetColor = ColorT.gray_99;
                              _highlightColor = ColorT.gray_99;
                            });
                          }
                        } else {
                          setState(() {
                            voiceText = '松开 结束';
                            _headsetColor = ColorT.gray_99;
                            _highlightColor = ColorT.gray_99;
                          });
                        }
                      },
                      child: new CircleAvatar(
                        child: new Text(
                          voiceText,
                          style: new TextStyle(
                              fontSize: 30.sp, color: ColorT.gray_33),
                        ),
                        radius: 120.w,
                        backgroundColor: voiceBackground,
                      ),
                    ))
              ],
            )),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                padding: EdgeInsets.all(20.w),
                child: Icon(
                  Icons.highlight_off,
                  color: _highlightColor,
                  size: 80.sp,
                ))),
      ],
    );
  }
  /// 获取录音文件秒数
  Future<double> _getDuration( String _path) async {
    Duration d = await flutterSoundHelper.duration(_path);
    if (d ==null) return 0;
    var _duration = d != null ? d.inMilliseconds / 1000.0: 0.00;
    print("_duration == $_duration");
    var minutes = d.inMinutes;
    var seconds = d.inSeconds % 60;
    var millSecond = d.inMilliseconds % 1000 ~/ 10;
    var _recorderTxt = "";
    if (minutes > 9) {
      _recorderTxt = _recorderTxt + "$minutes";
    } else {
      _recorderTxt = _recorderTxt + "0$minutes";
    }

    if (seconds > 9) {
      _recorderTxt = _recorderTxt + ":$seconds";
    } else {
      _recorderTxt = _recorderTxt + ":0$seconds";
    }
    if (millSecond > 9) {
      _recorderTxt = _recorderTxt + ":$millSecond";
    } else {
      _recorderTxt = _recorderTxt + ":0$millSecond";
    }
    print(_recorderTxt);
    return  d.inMilliseconds / 01000;
  }
  _startRecord() async {

    Vibration.vibrate(duration: 50);
    setState(() {
      voiceText = '松开 结束';
      voiceBackground = ColorT.divider;
      _stopRecorder();
    });
    try{
        requestPermiss(_permission);
        print('===>  获取了权限');
        Directory tempDir = await getTemporaryDirectory();
        var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        _voiceFilePath =
            '${tempDir.path}/s-$time${ext[Codec.aacADTS.index]}';
        print('===>  准备开始录音');
        await recorderModule.startRecorder(
          toFile: _voiceFilePath,
          codec: Codec.aacADTS,
          bitRate: 8000,
          sampleRate: 8000,
        );

        /// 监听录音
        _recorderSubscription = recorderModule.onProgress.listen((e) {
          if (e != null && e.duration != null) {
            var volume=e.decibels;
            setState(() {
              if (volume <= 0) {
                _audioIconPath = '';
              } else if (volume > 0 && volume < 30) {
                _audioIconPath = 'audio_player_1';
              } else if (volume < 50) {
                _audioIconPath = 'audio_player_2';
              } else if (volume < 100) {
                _audioIconPath = 'audio_player_3';
              }
            });
          }
        });

      } catch (err) {
      setState(() {
      _stopRecorder();
      _cancelRecorderSubscriptions();
      });
      }
  }
  /// 开始播放
  Future<void> _startPlayer(String _path ) async {
    try {
      var p=await _fileExists(_path);
      if (p !="") {
        await playerModule.startPlayer(
            fromURI: p,
            codec: Codec.aacADTS,
            whenFinished: () {
              print('==> 结束播放');
              _stopPlayer();
              setState(() {});
            });
      } else {
        throw RecordingPermissionException("未找到文件路径");
      }

      _cancelPlayerSubscriptions();
      _playerSubscription = playerModule.onProgress.listen((e) {
        if (e != null) {
          // print("${e.duration} -- ${e.position} -- ${e.duration.inMilliseconds} -- ${e.position.inMilliseconds}");
          // DateTime date = new DateTime.fromMillisecondsSinceEpoch(
          //     e.position.inMilliseconds,
          //     isUtc: true);
          // String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

          // this.setState(() {
          // this._playerTxt = txt.substring(0, 8);
          // });
        }
      });

      print('===> 开始播放');
    } catch (err) {
      print('==> 错误: $err');
    }
    setState(() {

    });
  }

  /// 结束播放
  Future<void> _stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('===> 结束播放');
      _cancelPlayerSubscriptions();
    } catch (err) {
      print('==> 错误: $err');
    }

  }

  /// 暂停/继续播放
  void _pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();

      print('===> 暂停播放');
    } else {
      playerModule.resumePlayer();

      print('===> 继续播放');
    }
    setState(() {});
  }

  /// 判断文件是否存在
  Future<String> _fileExists(String paths) async {

    if (paths.startsWith("http://localhost")) {

        File f =   await _getLocalFile(path.basename(paths));
        return _voiceFilePath;

    } else if(paths.startsWith("http")){
      return paths;
    }

    return paths;
  }
  _faceWidget() {
    _initFaceList();
    return Column(
      children: <Widget>[
        Flexible(
            child: Stack(
          children: <Widget>[
            Offstage(
              offstage: _isFaceFirstList,
              child: Swiper(
                  autoStart: false,
                  circular: false,
                  indicator: CircleSwiperIndicator(
                      radius: 3.0,
                      padding: EdgeInsets.only(top: 10.w),
                      itemColor: ColorT.gray_99,
                      itemActiveColor: ObjectUtil.getThemeSwatchColor()),
                  children: _guideFigureList),
            ),
            Offstage(
              offstage: !_isFaceFirstList,
              child: EmojiPicker(
                rows: 3,
                columns: 7,
                //recommendKeywords: ["racing", "horse"],
                numRecommended: 10,
                onEmojiSelected: (emoji, category) {
                  _controller.text = _controller.text + emoji.emoji;
                  _controller.selection =
                      TextSelection.fromPosition(
                          TextPosition(offset: _controller.text.length));

                  if (_isShowSend == false){

                    setState(() {
                      if (_controller.text.isNotEmpty) {
                        _isShowSend = true;
                      } else {
                        _isShowSend = false;
                      }
                    });

                  }
                },
              ),
            )

          ],
        )),
        SizedBox(
          height: 4.h,
        ),
        new Divider(height: 2.h),
        Container(
          height: 48.h,
          child: Row(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 20.w),
                      child: InkWell(
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          color: _isFaceFirstList
                              ? ObjectUtil.getThemeSwatchColor()
                              : _headsetColor,
                          size: 48.sp,
                        ),
                        onTap: () {
                          setState(() {
                            _isFaceFirstList = true;
                          });
                        },
                      ))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 20.w),
                      child: InkWell(
                        child: Icon(
                          Icons.favorite_border,
                          color: _isFaceFirstList
                              ? _headsetColor
                              : ObjectUtil.getThemeSwatchColor(),
                          size: 48.sp,
                        ),
                        onTap: () {
                          setState(() {
                            _isFaceFirstList = false;
                          });
                        },
                      ))),
            ],
          ),
        )
      ],
    );
  }

  _toolsWidget() {
    if (_guideToolsList.length > 0) {
      _guideToolsList.clear();
    }
    List<Widget> _widgets = new List();
    _widgets.add(MoreWidgets.buildIcon(Icons.insert_photo, '相册', o: (res) {
      ImageUtil.getGalleryImage().then((imageFile) {
        //相册取图片
        _willBuildImageMessage(imageFile);
      });
    }));
    _widgets.add(MoreWidgets.buildIcon(Icons.camera_alt, '拍摄', o: (res) {
      PopupWindowUtil.showCameraChosen(context, onCallBack: (type, file) {
        if (type == 1) {
          //相机取图片
          _willBuildImageMessage(file);
        } else if (type == 2) {
          //相机拍视频
          _buildVideoMessage(file);
        }
      });
    }));
    _widgets.add(MoreWidgets.buildIcon(Icons.videocam, '视频通话'));
    _widgets.add(MoreWidgets.buildIcon(Icons.location_on, '位置'));
    _widgets.add(MoreWidgets.buildIcon(Icons.view_agenda, '红包'));
    _widgets.add(MoreWidgets.buildIcon(Icons.swap_horiz, '转账'));
    _widgets.add(MoreWidgets.buildIcon(Icons.mic, '语音输入'));
    _widgets.add(MoreWidgets.buildIcon(Icons.favorite, '我的收藏'));
    _guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(5.0), children: _widgets));
    List<Widget> _widgets1 = new List();
    _widgets1.add(MoreWidgets.buildIcon(Icons.person, '名片'));
    _widgets1.add(MoreWidgets.buildIcon(Icons.folder, '文件'));
    _guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(0.0), children: _widgets1));
    return Swiper(
        autoStart: false,
        circular: false,
        indicator: CircleSwiperIndicator(
            radius: 3.0,
            padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
            itemColor: ColorT.gray_99,
            itemActiveColor: ObjectUtil.getThemeSwatchColor()),
        children: _guideToolsList);
  }

  _gridView(int crossAxisCount, List<String> list) {
    return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(0.0),
        children: list.map((String name) {
          return new IconButton(
              onPressed: () {
                if (name.contains('face_delete')) {
                  DialogUtil.buildToast('暂时不会把自定义表情显示在TextField，谁会的教我~');
                } else {
                  //表情因为取的是assets里的图，所以当初文本发送
                  _buildTextMessage(name);
                }
              },
              icon: Image.asset(name,
                  width: crossAxisCount == 5 ? 60.w : 32.w,
                  height: crossAxisCount == 5 ? 60.h : 32.h));
        }).toList());
  }

  /*输入框*/
  _enterWidget() {
    return new Material(
      borderRadius: BorderRadius.circular(12.w),
      shadowColor: ObjectUtil.getThemeLightColor(),
      color: ColorT.gray_f0,
      elevation: 0,
      child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6.w)),
          constraints: BoxConstraints(minHeight: 60.h, maxHeight: 250.h),
          child:new TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
          focusNode: _textFieldNode,
          textInputAction: TextInputAction.send,
          controller: _controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(150), //长度限制11
          ], //只能输入整数
          style: TextStyle(color: Colors.black, fontSize: 32.sp),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.w),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
          ),
          onChanged: (str) {
            setState(() {
              if (str.isNotEmpty) {
                _isShowSend = true;
              } else {
                _isShowSend = false;
              }
            });
          },
          onEditingComplete: () {
            if (_controller.text.isEmpty) {
              return;
            }
            _buildTextMessage(_controller.text);
          }
          )
      ),
    );
  }

  _messageListView(BuildContext context, PeerState peerState) {
    if (peerState is PeerMessageSuccess) {

      return Container(
          color: ColorT.gray_f0,
          child: Column(
            //如果只有一条数据，listView的高度由内容决定了，所以要加列，让listView看起来是满屏的
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 0,bottom: 0),
                    child: Text('',
                      style:
                      TextStyle(
                        fontSize: 24.sp,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                //外层是Column，所以在Column和ListView之间需要有个灵活变动的控件
                  child: _buildContent(context, peerState))
            ],
          ));
    }
    if (peerState is LoadMorePeerMessageSuccess) {
      bool isLastPage=peerState.noMore;
      return Container(
          color: ColorT.gray_f0,
          child: Column(
            //如果只有一条数据，listView的高度由内容决定了，所以要加列，让listView看起来是满屏的
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                    child: _isLoading
                        ? CupertinoActivityIndicator()
                        : Container(),
                  )
                ],
              ),

              Flexible(
                //外层是Column，所以在Column和ListView之间需要有个灵活变动的控件
                  child: _buildContent(context, peerState))
            ],
          ));
    }
    return Container();

  }
  Widget _buildContent(BuildContext context, PeerState state) {
    if (state is PeerMessageSuccess) {
      var messageLists =state.messageList;
      return     ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child:ListView.builder(
              padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 0,bottom: 0),
          itemBuilder: (BuildContext context, int index) {
            return _messageListViewItem(messageLists,index,tfSender);
          },
          //倒置过来的ListView，这样数据多的时候也会显示“底部”（其实是顶部），
          //因为正常的listView数据多的时候，没有办法显示在顶部最后一条
          reverse: true,
          //如果只有一条数据，因为倒置了，数据会显示在最下面，上面有一块空白，
          //所以应该让listView高度由内容决定
          shrinkWrap: true,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: messageLists.length));
    }
    if (state is LoadMorePeerMessageSuccess) {
      var messageLists =state.messageList;
      return     ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child: ListView.builder(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 0),
          itemBuilder: (BuildContext context, int index) {
            return _messageListViewItem(messageLists,index,tfSender);
          },
          //倒置过来的ListView，这样数据多的时候也会显示“底部”（其实是顶部），
          //因为正常的listView数据多的时候，没有办法显示在顶部最后一条
          reverse: true,
          //如果只有一条数据，因为倒置了，数据会显示在最下面，上面有一块空白，
          //所以应该让listView高度由内容决定
          shrinkWrap: true,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: messageLists.length));
    }
    return Container();
  }
  Future<Null> _onRefresh() async {

    BlocProvider.of<PeerBloc>(context).add(EventLoadMoreMessage());
  }

  Widget _messageListViewItem(List<Message>messageList, int index,String tfSender) {
    //list最后一条消息（时间上是最老的），是没有下一条了
    Message _nextEntity = (index == messageList.length - 1) ? null : messageList[index + 1];
    Message _entity = messageList[index];
    return buildChatListItem(_nextEntity, _entity,tfSender,
        onResend: (reSendEntity) {
      _onResend(reSendEntity);
        },
        onItemClick: (onClickEntity) async {
      Message entity = onClickEntity;
      if (entity.type == MessageType.MESSAGE_AUDIO){
        //点击了语音
        if (_entity.playing == 1) {
          //正在播放，就停止播放
          await _stopPlayer();
          setState(() {
            _entity.playing = 0;
          });
        } else {
          setState(()  {
            for (Message other in messageList) {
              other.playing = 0;
              //停止其他正在播放的
            }
          });
          _entity.playing = 1;
          await _startPlayer(_entity.content['url']);
          Future.delayed(Duration(milliseconds: _entity.content['duration']*1000), () async {
            if (_alive) {
              setState(()  {
                _entity.playing = 0;
              });
              await  _stopPlayer();
            }
          });
        }
      }
    });
  }
  Widget buildChatListItem(Message nextEntity, Message entity,String tfSender,
      {OnItemClick onResend, OnItemClick onItemClick}) {
    bool _isShowTime = true;
    var showTime; //最终显示的时间
    if (null == nextEntity) {
      //_isShowTime = true;
    } else {
      //如果当前消息的时间和上条消息的时间相差，大于3分钟，则要显示当前消息的时间，否则不显示
      if ((entity.timestamp*1000 - nextEntity.timestamp*1000).abs() > 3 * 60 * 1000) {
        _isShowTime = true;
      } else {
        _isShowTime = false;
      }
    }
    showTime=chatTimeFormat(entity.timestamp);

    return Container(
      child: Column(
        children: <Widget>[
          _isShowTime
              ? Center(
              heightFactor: 2,
              child: Text(
                showTime,
                style: TextStyle(color: ColorT.transparent_80),
              ))
              : SizedBox(height: 0),
          _chatItemWidget(entity, onResend, onItemClick,tfSender)
        ],
      ),
    );
  }

  String chatTimeFormat(int timestamp){
    var showTime ;
    int zeroTmp = DateTime.now().millisecondsSinceEpoch;
    var today = DateTime.now();
    var times =today.year.toString()+"-" +(today.month.toString().length ==2?today.month.toString():"0"+today.month.toString() )+"-"+(today.day.toString().length==2?today.day.toString():"0"+today.day.toString()) +" 00:00:00";
    var dd =DateTime.parse(times).millisecondsSinceEpoch;
    zeroTmp=dd;
    int nows=zeroTmp - (zeroTmp + 8 * 3600 *1000) % (86400*1000);
    //获取当前的时间,yyyy-MM-dd HH:mm
    String nowTime = DateUtil.getDateStrByMs(new DateTime.now().millisecondsSinceEpoch, format: DateFormat.ZH_MONTH_DAY_HOUR_MINUTE);
    //当前消息的时间,yyyy-MM-dd HH:mm
    String indexTime = DateUtil.getDateStrByMs(timestamp*1000, format: DateFormat.ZH_YEAR_MONTH_DAY_HOUR_MINUTE);
    String nowTime1 = DateUtil.getDateStrByMs(new DateTime.now().millisecondsSinceEpoch, format: DateFormat.ZH_NORMAL);
    //当前消息的时间,yyyy-MM-dd HH:mm
    String indexTime1 = DateUtil.getDateStrByMs(timestamp*1000, format: DateFormat.ZH_NORMAL);
    if (DateUtil.formatDateTime1(indexTime1, DateFormat.YEAR) != DateUtil.formatDateTime1(nowTime1, DateFormat.YEAR)) {
      //对比年份,不同年份，直接显示yyyy-MM-dd HH:mm
      showTime = indexTime1;
    } else if (DateUtil.formatDateTime1(indexTime1, DateFormat.ZH_YEAR_MONTH) != DateUtil.formatDateTime1(nowTime1, DateFormat.ZH_YEAR_MONTH)) {
      //年份相同，对比年月,不同月或不同日，直接显示MM-dd HH:mm
      if ((timestamp*1000)> nows ){
        showTime=""+DateUtil.formatDateTime1(indexTime, DateFormat.ZH_HOUR_MINUTE).substring( "MM月dd日 ".length,);
      } else if ((timestamp*1000> nows-1*24*3600*1000) && (timestamp*1000<nows)){
        showTime="昨天 "+DateUtil.formatDateTime1(indexTime, DateFormat.ZH_HOUR_MINUTE).substring( "MM月dd日 ".length,);
      }else if ((timestamp*1000> nows-2*24*3600*1000) && (timestamp*1000<1*24*3600*1000)){
        showTime="前天 "+DateUtil.formatDateTime1(indexTime, DateFormat.ZH_HOUR_MINUTE).substring( "MM月dd日 ".length,);
      } else if ((timestamp*1000) > nows-7*24*3600*1000 && (timestamp*1000) < nows-2*24*3600*1000){
        showTime=DateUtil.getZHWeekDay(DateTime.fromMillisecondsSinceEpoch(timestamp*1000, isUtc: false))+" "+DateUtil.formatDateTime1(indexTime, DateFormat.ZH_HOUR_MINUTE).substring( "MM月dd日 ".length,);
      } else{
        showTime = DateUtil.formatDateTime1(indexTime, DateFormat.ZH_MONTH_DAY_HOUR_MINUTE);
      }

    }  else {
      //否则HH:mm
      showTime = DateUtil.formatDateTime1(indexTime, DateFormat.ZH_HOUR_MINUTE);
    }

    return showTime;
  }




  Widget _chatItemWidget(Message entity, OnItemClick onResend,
      OnItemClick onItemClick,String tfSender) {
    if (entity.receiver == tfSender) {
      //对方的消息
      return Container(
        margin: EdgeInsets.only(left: 10.w, right: 40.w, bottom: 6.h, top: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headPortrait('', 1),
            SizedBox(width: 10.w),
             Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 0.w, right: 0.w, bottom: 0.h, top: 12.h),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: _contentWidget(entity,tfSender),
                        onTap: () {
                          if (null != onItemClick) {
                            onItemClick(entity);
                          }
                        },
                        onLongPress: () {
                          DialogUtil.buildToast('长按了消息');
                        },
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    } else {
      //自己的消息
      return Container(
        margin: EdgeInsets.only(left: 40.w, right: 10.w, bottom: 6.h, top: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
             Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 0.w, right: 0.w, bottom: 0.h, top: 12.h),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      SizedBox(height: 1.h),
                      GestureDetector(
                        child: _contentWidget(entity,tfSender),
                        onTap: () {
                          if (null != onItemClick) {
                            onItemClick(entity);
                          }
                        },
                        onLongPress: () {
                          DialogUtil.buildToast('长按了消息');
                        },
                      ),
                      //显示是否重发1、发送2中按钮，发送成功0或者null不显示
                      // entity.flags == 11
                      //     ? IconButton(
                      //     icon: Icon(Icons.refresh, color: Colors.red, size: 18),
                      //     onPressed: () {
                      //       if (null != onResend) {
                      //         onResend(entity);
                      //       }
                      //     })
                      //     : (entity.flags == 10
                      //     ? Container(
                      //   alignment: Alignment.center,
                      //   padding: EdgeInsets.only(top: 20, right: 20),
                      //   width: 32.0,
                      //   height: 32.0,
                      //   child: SizedBox(
                      //       width: 12.0,
                      //       height: 12.0,
                      //       child: CircularProgressIndicator(
                      //         valueColor: AlwaysStoppedAnimation(
                      //             ObjectUtil.getThemeSwatchColor()),
                      //         strokeWidth: 2,
                      //       )),
                      // )
                      //     : SizedBox(
                      //   width: 0,
                      //   height: 0,
                      // )),
                    ],
                  ),
                )),
            SizedBox(width: 10),
            _headPortrait('', 0),
          ],
        ),
      );
    }
  }

  /*
  *  头像
  */
  Widget _headPortrait(String url, int owner) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(6.w),
        child: url.isEmpty
            ? Image.asset(
            (owner == 1
                ? FileUtil.getImagePath('img_headportrait',
                dir: 'icon', format: 'png')
                : FileUtil.getImagePath('logo',
                dir: 'splash', format: 'png')),
            width: 88.w,
            height: 88.h)
            : (ObjectUtil.isNetUri(url)
            ? Image.network(
          url,
          width: 88.w,
          height: 88.h,
          fit: BoxFit.fill,
        )
            : Image.asset(url, width: 88, height: 88)));
  }

  /*
  *  内容
  */
  Widget _contentWidget(Message entity,String tfSender) {
    Widget widget;
    if (entity.type == MessageType.MESSAGE_TEXT) {
      //文本
      if (entity.content['text'].contains('assets/images/face') ||
          entity.content['text'].contains('assets/images/figure')) {
        widget = buildImageWidget(entity,tfSender);
      } else {
        widget = buildTextWidget(entity,tfSender);
      }

    } else if (entity.type == MessageType.MESSAGE_IMAGE) {
      //文本
      widget = buildImageWidget(entity,tfSender);
    } else if (entity.type == MessageType.MESSAGE_AUDIO) {
      //文本
      widget = buildVoiceWidget(entity,tfSender);
    } else {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(12.w),
        child: Container(
          padding: EdgeInsets.all(15.h),
          color: ObjectUtil.getThemeLightColor(),
          child: Text(
            '未知消息类型',
            style: TextStyle(fontSize: 30.sp, color: Colors.black),
          ),
        ),
      );
    }
    return widget;
  }

  Widget buildTextWidget(Message entity,String  tfSender) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.h, bottom: 16.h),
        color: entity.sender == tfSender
            ?Color.fromARGB(255, 158, 234, 106)
            : Colors.white,
        child: Text(
          entity.content['text'],
          style: TextStyle(fontSize: 32.sp, color: Colors.black),
        ),
      ),
    );
  }

  Widget buildImageWidget(Message message,String  tfSender) {
    int isFace =0;
    //图像
    double width = ValueUtil.toDouble(message.content['width']);
    double height = ValueUtil.toDouble(message.content['height']);
    String imageURL = ValueUtil.toStr(message.content['imageURL']);
    if (imageURL == null || imageURL.length == 0) {
      imageURL = ValueUtil.toStr(message.content['url']);
    }
    double size = 240.w;
    Widget image;
    if (message.type== MessageType.MESSAGE_TEXT&&
        message.content['text'].contains('assets/images/face')) {
      //assets/images/face中的表情
      size = 50.w;
      image = Image.asset(message.content['text'], width: size, height: size);
      isFace=1;
    } else if (message.type== MessageType.MESSAGE_TEXT &&
        message.content['text'].contains('assets/images/figure')) {
      //assets/images/figure中的表情
      size = 120.w;
      image = Image.asset(message.content['text'], width: size, height: size);
      isFace=1;
    }
    return _buildWrapper(
      isSelf: message.sender== tfSender,
      message: message,
      child: isFace==1?

      ClipRRect(
        borderRadius: BorderRadius.circular(8.w),
        child: Container(
          padding: EdgeInsets.all((message.content['text'].isNotEmpty &&
              message.content['text'].contains('assets/images/face'))
              ? 10.w
              : 0),
          color: message.sender == tfSender
              ? Colors.white
              : Color.fromARGB(255, 158, 234, 106),
          child: image,
        ),
      ):

      Container(
        decoration: new BoxDecoration(
          //背景Colors.transparent 透明
          color: Colors.transparent,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
          //设置四周边框

        ),

        width: 190.w,
        height: 220.h,
        child: //Image.network(imageURL)
        GestureDetector(
           child:
            //FutureBuilder(
          //   future: getLocalCacheImage(url: imageURL),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState != ConnectionState.done) {
          //       return Container();
          //     }
          //     if (snapshot.hasData) {
          //       return Image.memory(snapshot.data);
          //     } else {
          //       if (imageURL.startsWith("http://localhost")) {
          //         return Container();
          //       } else if (imageURL.startsWith('file:/')) {
          //         return Image.file(File(imageURL));
          //       }
          //       return Image.network(imageURL);
          //     }
          //   },
          // ),
           buildLocalImageWidget(imageURL),
           // Image.network(imageURL),
          onTap: () {

              ImagePreview.preview(
                context,
                images: List.generate(1, (index) {
                  return ImageOptions(
                    url: imageURL,
                    tag: imageURL,
                  );
                }),
                // bottomBarBuilder: (context, int index) {
                //   if (index % 4 == 1) {
                //     return SizedBox.shrink();
                //   }
                //   return Container(
                //     height: index.isEven ? null : MediaQuery.of(context).size.height / 2,
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 10,
                //     ),
                //     child: SafeArea(
                //       top: false,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             '测试标题',
                //             style: TextStyle(
                //               color: CupertinoDynamicColor.resolve(
                //                 CupertinoColors.label,
                //                 context,
                //               ),
                //             ),
                //           ),
                //           Text(
                //             '测试内容',
                //             style: TextStyle(
                //               fontSize: 15,
                //               color: CupertinoDynamicColor.resolve(
                //                 CupertinoColors.secondaryLabel,
                //                 context,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   );
                // },
              );

          },
          onLongPress: () {
            DialogUtil.buildToast('长按了消息');
          },
        )

      ),
    );
  }
   Widget buildVoiceWidget(Message entity,String  tfSender) {
    double width;
    if (entity.content['duration'] < 5) {
      width = 160.w;
    } else if (entity.content['duration'] < 10) {
      width = 240.w;
    } else if (entity.content['duration'] < 20) {
      width = 280.w;
    } else {
      width = 300.w;
   }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          width: width,
          color: entity.sender == tfSender
              ? Colors.white
              : Color.fromARGB(255, 158, 234, 106),
          child: Row(
            mainAxisAlignment: entity.sender == tfSender
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: <Widget>[
              entity.sender == tfSender
                  ? Text('')
                  : Text((entity.content['duration']).toString() + 's',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
              SizedBox(
                width: 5,
              ),
              entity.playing == 1
                  ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 1, right: 1),
                width: 18.0,
                height: 18.0,
                child: SizedBox(
                    width: 14.0,
                    height: 14.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                      strokeWidth: 2,
                    )),
              )
                  : Image.asset(
                FileUtil.getImagePath('audio_player_3',
                    dir: 'icon', format: 'png'),
                width: 18,
                height: 18,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              entity.sender == tfSender
                  ? Text((entity.content['duration']).toString() + 's',
                  style: TextStyle(fontSize: 18, color: Colors.black))
                  : Text(''),
            ],
          )),
    );
  }
  Widget buildLocalImageWidget(String imageURL) {
    if (imageURL.startsWith("http://localhost")) {
      return FutureBuilder(
        future: getLocalCacheImage(url: imageURL),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          if (snapshot.hasData) {
            return Image.memory(snapshot.data);
          } else {
            if (imageURL.startsWith("http://localhost")) {
              return Container();
            } else if (imageURL.startsWith('file:/')) {
              return Image.file(File(imageURL));
            }
            return Image.network(imageURL);
          }
        },
      );
       } else if (imageURL.startsWith('file:/')) {
              return Image.file(File(imageURL.substring(6)));
       }
              return CachedNetworkImage(
                imageUrl: imageURL,
               // placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              );

                Image.network(imageURL);

  }

  Future<Uint8List> getLocalCacheImage({String url}) async {

    Map result = await im.getLocalCacheImage(url: url);
    NativeResponse response = NativeResponse.fromMap(result);
    return response.data;
  }
  Future<Uint8List> getLocalMediaURL({String url}) async {

    Map result = await im.getLocalMediaURL(url: url);
    NativeResponse response = NativeResponse.fromMap(result);
    return response.data;
  }



  Future<File> _getLocalFile(String filename) async {
    String dir = (await getTemporaryDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }
  _buildWrapper({bool isSelf, Message message, Widget child}) {
    return Container(
      margin: EdgeInsets.all(1.w),
      child: Row(
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [

          Container(
            child: child,
          ),

        ],
      ),
    );
  }


  Widget buildVideoWidget(MessageEntity entity) {

  }
  /*删除好友*/
  _deleteContact(String username) {

  }

  /*加入黑名单*/
  _addToBlackList(String isNeed, String username) {

  }

  /*移出黑名单*/
  _removeUserFromBlackList(String username) {

  }

  //重发
  _onResend(Message entity) {

  }

  _buildTextMessage(String content) {
    BlocProvider.of<PeerBloc>(context).add(EventSendNewMessage(tfSender,widget.model.cid,content));
    //setState(() {
      _controller.clear();
      _isShowSend = false;
    //});

  }
  sendTextMessage(String text) async {
    if (text == null || text.length == 0) {

      return;
    }



  }
  _willBuildImageMessage(File imageFile) {
    if (imageFile == null || imageFile.path.isEmpty) {
      return;
    }
    _buildImageMessage(imageFile, false);return;
    DialogUtil.showBaseDialog(context, '是否发送原图？',
        title: '', right: '原图', left: '压缩图', rightClick: (res) {
      _buildImageMessage(imageFile, true);
    }, leftClick: (res) {
      _buildImageMessage(imageFile, false);
    });

  }

  _buildImageMessage(File file, bool sendOriginalImage)  {
   file.readAsBytes().then((content) =>
       BlocProvider.of<PeerBloc>(context).add(EventSendNewImageMessage(tfSender,widget.model.cid,content))
      );

    //setState(() {
       _isShowTools = false;
      _controller.clear();
    //});

  }

  _buildVoiceMessage(File file, int length) {

    //setState(() {
    BlocProvider.of<PeerBloc>(context).add(EventSendNewVoiceMessage(tfSender,widget.model.cid,file.path,length.floor()));
      _controller.clear();
   // });

  }

  _buildVideoMessage(Map file) {


    setState(() {

      _controller.clear();
    });

  }

  _sendMessage(Message messageEntity, {bool isResend = false}) {
    if (isResend) {
      setState(() {

      });
    }

  }

  @override
  void updateData(Message entity) {
    // TODO: implement updateData

  }
}


















