import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

App app = App();

class App {
  static final App _app = App._();

  factory App() => _app;

  App._();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => navigatorKey?.currentState;

  OverlayState get overlay => navigatorKey?.currentState?.overlay;
}

 Duration _kDuration =  const Duration(milliseconds: 300);

 typedef OnSelectCallback = void Function(int);

class MenuSphere extends StatefulWidget{
  const MenuSphere(this.onSelectCallback);
  final OnSelectCallback onSelectCallback;
  @override
  _MenuSphereState createState() => _MenuSphereState();
}

class _MenuSphereState extends State<MenuSphere> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<double> _tween;
  Animation<double> _animation;
  final GlobalKey _key = GlobalKey();
  final StreamController<bool> _streamController = StreamController.broadcast();
  Offset _offset;
  OnSelectCallback _onSelectCallback;
  double _size;
  final String url = 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3944406325,3397489600&fm=26&gp=0.jpg';

  @override
  void initState() {
    super.initState();
    _size = 50.0;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _tween = Tween<double>(begin: 0.0, end: 0.125);
    _animation = _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _onSelectCallback = (int index) {
      _end();
      Future<void>.delayed(_kDuration,(){
        widget.onSelectCallback(index);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
          final RenderBox renderBox = _key.currentContext.findRenderObject() as RenderBox;
    _offset = renderBox.localToGlobal(Offset.zero);
    return WillPopScope(
        onWillPop: () async {
          _end();
          return hasOpen;
        },
      child: Column(
        children: [
                      SphereItem(
                          path: url,
                          model: SpherePosition(offset: _offset,
                              size: _size,
                              directionX: 0,directionY: 70,
                              direction: 4,id: 1),
                          stream: _streamController.stream,
                          onSelectCallback: _onSelectCallback)


        ],
      ),
        // child: GestureDetector(
        //     behavior: HitTestBehavior.opaque,
        //     onTap: () {
        //       final RenderBox renderBox = _key.currentContext.findRenderObject() as RenderBox;
        //       _offset = renderBox.localToGlobal(Offset.zero);
        //       _open();
        //       group = <OverlayEntry>[
        //         OverlayEntry(builder: (BuildContext context) => GestureDetector(
        //             behavior: HitTestBehavior.opaque,
        //             onTap: (){
        //               _end();
        //             },
        //             child: const Material(color: Colors.transparent))),
        //         OverlayEntry(builder: (BuildContext context) =>
        //             SphereItem(
        //                 path: url,
        //                 model: SpherePosition(offset: _offset,
        //                     size: _size,
        //                     directionX: 0,directionY: 70,
        //                     direction: 4,id: 1),
        //                 stream: _streamController.stream,
        //                 onSelectCallback: _onSelectCallback)),
        //         OverlayEntry(builder: (BuildContext context) =>
        //             SphereItem(
        //                 path: url,
        //                 model: SpherePosition(
        //                     size: _size,offset: _offset,
        //                     directionX: 60,directionY: -40,
        //                     direction: 6,id: 0),
        //                 stream: _streamController.stream,
        //                 onSelectCallback: _onSelectCallback))
        //       ];
        //      app.overlay.insertAll(list);
        //     },
        //     child: RotationTransition(
        //         key: _key,
        //         turns: _animation,
        //         child: Container(
        //             width: _size,
        //             height: _size,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 image: DecorationImage(
        //                     image: NetworkImage(url))
        //             )
        //         ))
        // )
    );
  }

  final List<OverlayEntry> _overlayList = <OverlayEntry>[];

  List<OverlayEntry> get list => _overlayList;

  set group(List<OverlayEntry> value) => _overlayList.addAll(value);

  int get length => list.length;

  bool hasOpen = false;

  void _open(){
    _controller?.forward();
    setState(() {
      hasOpen = !hasOpen;
    });
  }

  void _end(){
    _streamController.add(false);
    _controller?.reverse();
    Future<void>.delayed(_kDuration, () {
      hasOpen = false;
      if (list.isNotEmpty)
        for (int i = 0;i<list.length;i++){
          list[i].remove();
          list.removeAt(i);
          i--;
        }
    });
  }

  @override
  void dispose() {
    _streamController.close();
    _controller.dispose();
    _controller = null;
    _onSelectCallback = null;
    super.dispose();
  }
}

class SpherePosition {
  SpherePosition({
    this.id,
    this.size,
    this.offset,
    this.directionX = 0,
    this.directionY = 0,
    this.direction = 0
  }){
    x = offset.dx;
    y = offset.dy;
    _positionX = offset.dx;
    _positionY = offset.dy;
  }

  final double directionX,directionY;
  final Offset offset;
  final int direction,id;
  final double size;
  double x,y,_positionX,_positionY;
  bool hasStart = false;

  void top() => _positionY = y - (hasStart ? 0 : directionY);

  void bottom() => _positionY = y + (hasStart ? 0 : directionY);

  void left() => _positionX = x - (hasStart ? 0 : directionX);

  void right() => _positionX = x + (hasStart ? 0 : directionX);

  double get positionX => _positionX ?? 0.0;
  double get positionY => _positionY ?? 0.0;
}

class SphereItem extends StatefulWidget {
  const SphereItem({Key key,@required this.path,@required this.model,this.stream,this.onSelectCallback}): super(key:key);
  final Stream<bool> stream;
  final SpherePosition model;
  final OnSelectCallback onSelectCallback;
  final String path;

  @override
  _SphereItemState createState() => _SphereItemState();
}

class _SphereItemState extends State<SphereItem> with SingleTickerProviderStateMixin {
  bool _isStart = false;
  AnimationController _controller;
  Tween<Offset> _positionTween;
  Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kDuration, vsync: this);
    _positionTween = Tween<Offset>(begin: const Offset(1, 1), end: const Offset(1, 1));
    switch(widget.model.direction){
      case 0: //上边
        widget.model.top();
        break;
      case 1: //下边
        widget.model.bottom();
        break;
      case 2: //左边
        widget.model.left();
        break;
      case 3: //右边
        widget.model.right();
        break;
      case 4: //左上角
        widget.model.top();
        widget.model.left();
        break;
      case 5: //右上角
        widget.model.top();
        widget.model.right();
        break;
      case 6: //左下角
        widget.model.left();
        widget.model.bottom();
        break;
      case 7:  //右下角
        widget.model.right();
        widget.model.bottom();
        break;
    }
    _positionTween = Tween<Offset>(begin: widget.model.offset,
        end: Offset(widget.model.positionX, widget.model.positionY));
    _positionAnimation = _positionTween.animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _controller.forward();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed)
        setState(() {
          _isStart=!_isStart;
          widget.model.hasStart = _isStart;
        });
    });
    _controller.addListener(() {
      if (mounted)
        setState(() {});
    });
    widget.stream.listen((bool value) {
      _positionTween?.begin = widget.model.offset;
      _controller?.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _positionAnimation,
        builder: (BuildContext context, _) {
          return Transform.translate(
              offset: _positionAnimation.value,
              child: CustomSingleChildLayout(
                  delegate: FixedSizeLayoutDelegate(Size(widget.model.size, widget.model.size)),
                  child: GestureDetector(
                      onTap: () => widget.onSelectCallback(widget.model.id),
                      child: Container(
                        width: widget.model.size,
                        height: widget.model.size,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:  DecorationImage(image: NetworkImage(widget.path))
                        ),
                      )
                  )
              )
          );
        });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}


class FixedSizeLayoutDelegate extends SingleChildLayoutDelegate {
  const FixedSizeLayoutDelegate(this.size);
  final Size size;

  @override
  Size getSize(BoxConstraints constraints) => size;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tight(size);
  }

  @override
  bool shouldRelayout(FixedSizeLayoutDelegate oldDelegate) {
    return size != oldDelegate.size;
  }
}