import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ThemeMode currentTheme = ThemeMode.light;

enum TypeSetting { typeSwitch, typeDialog }

class ChangeAppTheme extends StatefulWidget {
  final OnThemeChangeCallback? onThemeChangeCallback;
  final TypeSetting typeSetting;
  final String textValue;

  const ChangeAppTheme(
      {super.key,
      required this.onThemeChangeCallback,
      required this.typeSetting,
      required this.textValue});

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
        : TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0)), //this right here
                    child: SizedBox(
                      height: 300.0,
                      width: 300.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                              onPressed: () {
                                widget
                                    .onThemeChangeCallback!(ThemeData.light());
                              },
                              child: const Text(
                                'Light',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                              onPressed: () {
                                widget.onThemeChangeCallback!(ThemeData.dark());
                              },
                              child: const Text(
                                'Dark',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextButton(
                              onPressed: () {
                                if (brightness == Brightness.dark) {
                                  widget
                                      .onThemeChangeCallback!(ThemeData.dark());
                                } else {
                                  widget.onThemeChangeCallback!(
                                      ThemeData.light());
                                }
                              },
                              child: const Text(
                                'System Default',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              widget.textValue,
              style: Theme.of(context).primaryTextTheme.titleSmall,
            ),
          );
  }
}

typedef OnThemeChangeCallback = Function(ThemeData value);
