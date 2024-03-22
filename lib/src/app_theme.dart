import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ThemeMode currentTheme = ThemeMode.light;

enum TypeSetting { typeSwitch, typeDialog }

class ChangeAppTheme extends StatefulWidget {
  final OnThemeChangeCallback? onThemeChangeCallback;
  final TypeSetting typeSetting;
  const ChangeAppTheme(
      {super.key,
      required this.onThemeChangeCallback,
      required this.typeSetting});

  @override
  State<ChangeAppTheme> createState() => _ChangeAppThemeState();
}

class _ChangeAppThemeState extends State<ChangeAppTheme> {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isChange = false;

  @override
  void initState() {
    super.initState();
    if (widget.typeSetting == TypeSetting.typeDialog) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Light',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Dark',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 50.0)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'System Default',
                        style: TextStyle(color: Colors.purple, fontSize: 18.0),
                      ))
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.typeSetting == TypeSetting.typeSwitch
        ? Switch(
            value: isChange,
            onChanged: (value) {
              if (value && brightness == Brightness.light) {
                widget.onThemeChangeCallback!(ThemeData.dark());
              } else {
                widget.onThemeChangeCallback!(ThemeData.light());
              }
              isChange = value;
              setState(() {});
            },
          )
        : Container();
  }
}

typedef OnThemeChangeCallback = Function(ThemeData value);
