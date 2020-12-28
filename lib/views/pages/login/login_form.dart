import 'package:flutter_geen/app/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/res/toly_icon.dart';
import 'package:flutter_geen/blocs/login/login_state.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/blocs/login/login_bloc.dart';
import 'package:flutter_geen/blocs/login/login_event.dart';

class LoginFrom extends StatefulWidget {
  @override
  _LoginFromState createState() => _LoginFromState();
}

class _LoginFromState extends State<LoginFrom> {
  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  bool _showPwd = false;

  @override
  Widget build(BuildContext context) {
    return

      BlocListener<LoginBloc, LoginState>(
        listener: (ctx, state) {
            if (state is LoginFailed) {
              Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${state.reason}'),
              backgroundColor: Colors.red,
          ));
              BlocProvider.of<LoginBloc>(context).add(
                EventLoginFailed(),
              );
        }
                 if (state is LoginSuccess) {
                   BlocProvider.of<LoginBloc>(context).add(
                     EventLoginFailed(),
                   );
                Navigator.of(context).pushReplacementNamed(UnitRouter.nav);
            }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
              builder:_buildLoginByState
          )
          );
  }


  Widget _buildLoginByState(BuildContext context,LoginState state) {
    return Stack(
      children: [
      Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("登录",style: TextStyle(fontSize: 25),),
        SizedBox(height: 5,),
        Text("请使用手机号登录",style: TextStyle(color: Colors.grey),),
        SizedBox(height:20,),
        buildUsernameInput(),
        Stack(
          alignment: Alignment(.8,0),
          children: [
            buildPasswordInput(),
            FeedbackWidget(
                onPressed: ()=> setState(() => _showPwd=!_showPwd),
                child: Icon(_showPwd?TolyIcon.icon_show:TolyIcon.icon_hide)
            )
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(value: true, onChanged: (e) => {}),
            Text(
              "自动登录",
              style: TextStyle(color: Color(0xff444444), fontSize: 14),
            ),
            Spacer(),
            Text(
              "如何注册?",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline),
            )
          ],
        ),
        _buildBtn(state),
        buildOtherLogin(),
        Container(
          child: state is LoginLoading
              ? CircularProgressIndicator()
              : null,
        )

      ],
    ),


      ],


    );

  }


  void _doLogIn() {

    print('---用户名:${_usernameController.text}------密码：${_passwordController.text}---');
    if (_usernameController.text.isEmpty){
      return;
    }
    if (_passwordController.text.isEmpty){
      return;
    }
   BlocProvider.of<LoginBloc>(context).add(
     EventLogin(
         username: _usernameController.text,
         password: _passwordController.text),
   );
  }

  Widget _buildBtn(LoginState state) => Container(
    margin: EdgeInsets.only(top: 10, left: 10, right: 10,bottom: 0),
    height: 40,
    width: MediaQuery.of(context).size.width,
    child:
    RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: Colors.blue,
      onPressed: state is LoginInital?  _doLogIn :null,
      child: Text("登   录",
          style: TextStyle(color: Colors.white, fontSize: 18)),
    ),
  );

  Widget buildUsernameInput(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
                margin: const EdgeInsets.only(left: 00.0, right: 10.0),
              ),
              Expanded(
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入用户名...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildPasswordInput(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 30.0,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
                margin: const EdgeInsets.only(left: 00.0, right: 10.0),
              ),
              Expanded(
                child: TextField(
                  obscureText: !_showPwd,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入密码...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
  Widget buildOtherLogin(){
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: Row(
            children: [
              Expanded(child: Divider(height: 20,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('',style: TextStyle(color: Colors.grey),),
              ),
              Expanded(child: Divider(height: 20,)),
            ],
          ),
        ),
        Icon(TolyIcon.icon_kafei,color: Colors.black, size: 30,)
      ],
    );
  }
}
