import 'package:flutter/material.dart';
import 'package:flutter_geen/views/items/horizontal_pickers.dart';
import 'package:flutter_geen/views/pages/utils/dynamaicTheme.dart';
import 'package:flutter_geen/views/pages/utils/enums.dart';
import 'package:flutter_geen/views/pages/utils/extractedWidgets.dart';
import 'package:flutter_geen/views/pages/utils/textStyles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_geen/views/pages/home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  Color inActiveColor = Colors.grey[200];
  Color inActiveColorDark = Colors.grey[600];
  Color activeColor = Colors.redAccent;

  double age = 18, weight = 60, height = 170;

  List<String> activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extremly Active'
  ];
  List<String> goals = ['Loose Weight', 'Maintain Weight', 'Gain Weight'];

  String activityLevelValue = 'Moderately Active';
  String goalValue = 'Loose Weight';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final blockVertical = mediaQuery.size.height / 100;
    return Scaffold(
      key: _scaffoldKey,

      body: Column(
        children: <Widget>[
          // App title
          Padding(
            padding:  EdgeInsets.only(top: 60.h, left: 22.w, right: 2.w,bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Hero(
                  tag: "appBarTitle",
                  child: Text(
                    "用户创建",
                    style: isThemeDark(context)
                        ? TitleTextStyles.dark
                        : TitleTextStyles.light,
                  ),
                ),
             
              ],
            ),
          ),


          Expanded(
            child: ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child:ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Hero(
                            tag: "topContainer",
                            child: Material(
                              type: MaterialType.transparency,
                              child: SingleChildScrollView(
                                child: MyContainerTile(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child:  TextField(
                                                  autofocus: false,
                                                  style: TextStyle(color: Colors.black, fontSize: 17),
                                                  controller: _usernameController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: "姓名",
                                                      labelStyle: TextStyle(color: Colors.green),
                                                      hintText: "请输入...",
                                                      enabledBorder: const OutlineInputBorder(
                                                        borderSide:
                                                        const BorderSide(color: Colors.green, width: 1),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5.0)
                                                      )
                                                  )
                                              )
                                          )
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 6),
                                              child: Material(
                                                color: selectedGender ==
                                                        Gender.male
                                                    ? activeColor
                                                    :  inActiveColor,
                                                elevation: 4.0,
                                                borderRadius:
                                                    BorderRadius.circular(12.w),
                                                shadowColor: Colors.grey,
                                                child: InkWell(
                                                  splashColor: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.w),
                                                  child: Container(
                                                    height: blockVertical * 5.5,
                                                    child: Center(
                                                        child: Text(
                                                      "男",
                                                      style:
                                                      TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight: FontWeight.w600,
                                                        decoration: TextDecoration.none,
                                                        fontSize: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedGender =
                                                          Gender.male;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 12.h, horizontal: 6.w),
                                              child: Material(
                                                color: selectedGender ==
                                                        Gender.female
                                                    ? activeColor
                                                    : isThemeDark(context)
                                                        ? inActiveColorDark
                                                        : inActiveColor,
                                                elevation: 4.0,
                                                borderRadius:
                                                    BorderRadius.circular(12.w),
                                                shadowColor: Colors.grey,
                                                child: InkWell(
                                                  splashColor: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.w),
                                                  child: Container(
                                                    height: blockVertical * 5.5,
                                                    child: Center(
                                                        child: Text(
                                                      "女",
                                                      style:
                                                          isThemeDark(context)
                                                              ? HomeTitleStyle
                                                                  .dark
                                                              : HomeTitleStyle
                                                                  .light,
                                                    )),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedGender =
                                                          Gender.female;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      //! height slider
                                      Container(
                                        margin: EdgeInsets.all(6.w),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "身高",
                                                  style: isThemeDark(context)
                                                      ? HomeTitleStyle.dark
                                                      : HomeTitleStyle.light,
                                                ),
                                                Text(
                                                  "${height.toStringAsFixed(0)} cm",
                                                  style: isThemeDark(context)
                                                      ? TextUnitStyle.dark
                                                      : TextUnitStyle.light,
                                                ),
                                              ],
                                            ),
                                            SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTrackColor: activeColor,
                                                inactiveTrackColor:
                                                    inActiveColor,
                                                trackShape:
                                                    CustomTrackShape(), //RoundedRectSliderTrackShape(),
                                                trackHeight: 8.0,
                                                thumbColor: Colors.redAccent,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            12.w),
                                                overlayColor:
                                                    Colors.red.withAlpha(32),
                                              ),
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: Slider(
                                                  min: 100,
                                                  max: 220,
                                                  value: height,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      String val = value
                                                          .toStringAsFixed(0);
                                                      height =
                                                          double.parse(val);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //! weight slider
                                      Container(
                                        margin: EdgeInsets.all(6.w),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "体重",
                                                  style: isThemeDark(context)
                                                      ? HomeTitleStyle.dark
                                                      : HomeTitleStyle.light,
                                                ),
                                                Text(
                                                  "${weight.toStringAsFixed(0)} kg",
                                                  style: isThemeDark(context)
                                                      ? TextUnitStyle.dark
                                                      : TextUnitStyle.light,
                                                ),
                                              ],
                                            ),
                                            SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTrackColor: activeColor,
                                                inactiveTrackColor:
                                                    inActiveColor,
                                                trackShape:
                                                    CustomTrackShape(), //RoundedRectSliderTrackShape(),
                                                trackHeight: 8.0,
                                                thumbColor: Colors.redAccent,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            12.w),
                                                overlayColor:
                                                    Colors.red.withAlpha(32),
                                              ),
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: Slider(
                                                  min: 20,
                                                  max: 140,
                                                  value: weight,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      String val = value
                                                          .toStringAsFixed(0);
                                                      weight =
                                                          double.parse(val);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // age number picker
                                      Container(
                                        padding: EdgeInsets.all(6.w),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "年龄",
                                                  style: isThemeDark(context)
                                                      ? HomeTitleStyle.dark
                                                      : HomeTitleStyle.light,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                      //margin: EdgeInsets.all(10),
                                      height: 200.h,
                                      child: HorizantalPicker(
                                        minValue: 5,
                                        maxValue: 80,
                                        divisions: 75,
                                        showCursor: false,
                                        suffix: " 岁",
                                        backgroundColor: isThemeDark(context)
                                            ? Colors.grey[800]
                                            : Colors.white,
                                        initialPosition: InitialPosition.center,
                                        activeItemTextColor: Colors.redAccent,
                                        onChanged: (value) {
                                          setState(() {
                                            age = value;
                                          });
                                        },
                                      )),
                                      //SizedBox(height: 12)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //! second container
                          Hero(
                            tag: "bottomContainer",
                            child: Material(
                              type: MaterialType.transparency,
                              child: SingleChildScrollView(
                                child: MyContainerTile(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "学历",
                                        style: isThemeDark(context)
                                            ? HomeTitleStyle.dark
                                            : HomeTitleStyle.light,
                                      ),
                                      Padding(
                                        padding:
                                             EdgeInsets.only(left: 10.w),
                                        child: DropdownButton<String>(
                                          value: activityLevelValue,
                                          icon:
                                              Icon(FontAwesomeIcons.caretDown),
                                          iconSize: 18,
                                          elevation: 4,
                                          underline: Container(
                                            height: 3.h,
                                            color: Colors.redAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              activityLevelValue = newValue;
                                            });
                                          },
                                          items: activityLevels
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                _buildDegree(value),
                                                style: isThemeDark(context)
                                                    ? TextUnitStyle.dark
                                                    : TextUnitStyle.light,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(width: 24.w),
                                      Text(
                                        "大学",
                                        style: isThemeDark(context)
                                            ? HomeTitleStyle.dark
                                            : HomeTitleStyle.light,
                                      ),
                                      Padding(
                                        padding:
                                             EdgeInsets.only(left: 10.w),
                                        child: DropdownButton<String>(
                                          value: goalValue,
                                          icon:
                                              Icon(FontAwesomeIcons.caretDown),
                                          iconSize: 18,
                                          elevation: 4,
                                          underline: Container(
                                            height: 3.h,
                                            color: Colors.redAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              goalValue = newValue;
                                            });
                                          },
                                          items: goals
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: isThemeDark(context)
                                                    ? TextUnitStyle.dark
                                                    : TextUnitStyle.light,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
            ),
          ),
        ],
      ),
    );
  }
String _buildDegree(String value){
    if(value == "Sedentary"){
      return "博士后";
    }
    if(value == "Lightly Active"){
      return "博士";
    }
    if(value == "Moderately Active"){
      return "硕士";
    }
    if(value == "Very Active"){
      return "本科";
    }
    if(value == "Extremly Active"){
      return "专科";
    }

    return "本科";
}
  ActivityLevel getActivityLevel() {
    if (activityLevelValue == "Sedentary")
      return ActivityLevel.sedentary;
    else if (activityLevelValue == "Lightly Active")
      return ActivityLevel.lightlyActive;
    else if (activityLevelValue == "Moderately Active")
      return ActivityLevel.moderatelyActive;
    else if (activityLevelValue == "Very Active")
      return ActivityLevel.veryActive;
    else if (activityLevelValue == "Extremly Active")
      return ActivityLevel.extremlyActive;
    else
      return null;
  }

  Goal getGoal() {
    if (goalValue == "Loose Weight")
      return Goal.looseWeight;
    else if (goalValue == "Maintain Weight")
      return Goal.maintainWeight;
    else if (goalValue == "Gain Weight")
      return Goal.gainWeight;
    else
      return null;
  }
}
