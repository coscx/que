import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class GoodsAddMenu extends StatefulWidget {
  final String uuid;
  const GoodsAddMenu({
    Key key, this.uuid,
  }) : super(key: key);

  @override
  _GoodsAddMenuState createState() => _GoodsAddMenuState();
}

class _GoodsAddMenuState extends State<GoodsAddMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.white;
    final Color iconColor = Colors.black;

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.only(right: 24.w),
          child: Image.asset('assets/images/jt.png', width: 32.w, height: 16.h,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(
            onPressed: () async {
                                var actionList =
                                    await IssuesApi.claimCustomer(widget.uuid);
                                if (actionList['code'] == 200) {
                                  showToast(context, '认领成功', true);

                                  Map<String, dynamic> photo = Map();
                                  photo['uuid'] = widget.uuid;
                                  BlocProvider.of<DetailBloc>(context)
                                      .add(FetchWidgetDetailNoFresh(photo));
                                } else {
                                  showToastRed(
                                      context, actionList['message'], true);
                                }
                                Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.assignment_ind_outlined,
              color: Colors.black,
            ),
            label: const Text('认领用户'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.bodyText2?.color,
              onSurface: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.color
                  ?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
        Container(width: 120.0, height: 0.6, color: Colors.lightBlue),
        SizedBox(
          width: 120.0,
          height: 40.0,
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.add_to_drive,
              color: Colors.black,
            ),
            label: const Text('划分用户'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.bodyText2?.color,
              onSurface: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.color
                  ?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.topRight,
          child: child,
        );
      },
      child: body,
    );
  }
}
