import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';

ThemeMode currentTheme = ThemeMode.light;

enum TypeSetting { typeSwitch, typeDialog }

enum SingingCharacter { light, dark, systemDefault }

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
  PackageInfo? packageInfo;
  InitFunction? initFunction;
  SingingCharacter? character = SingingCharacter.light;

  @override
  void initState() {
    initFunction!.initSharedPref();
    getAppName();
    var prefValue = initFunction!.getPrefValue("theme", 0);

    if (prefValue == 2) {
      /// get current device brightness
      var dispatcher = SchedulerBinding.instance.platformDispatcher;

      // This callback is called every time the brightness changes.
      dispatcher.onPlatformBrightnessChanged = () {
        brightness = dispatcher.platformBrightness;
        initFunction!.setPrefValue("theme", 2);
        if (brightness == Brightness.dark) {
          widget.onThemeChangeCallback!(ThemeData.dark());
        } else {
          widget.onThemeChangeCallback!(ThemeData.light());
        }
        setState(() {});
      };
    } else if (prefValue == 1) {
      widget.onThemeChangeCallback!(ThemeData.dark());
      initFunction!.setPrefValue("theme", 1);
      setState(() {});
    } else {
      widget.onThemeChangeCallback!(ThemeData.light());
      initFunction!.setPrefValue("theme", 0);
      setState(() {});
    }
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
                initFunction!.setPrefValue("theme", 1);
              } else {
                widget.onThemeChangeCallback!(ThemeData.light());
                initFunction!.setPrefValue("theme", 0);
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
                          RadioListTile<SingingCharacter>(
                            title: const Text('Light'),
                            value: SingingCharacter.light,
                            groupValue: character,
                            onChanged: (SingingCharacter? value) {
                              widget.onThemeChangeCallback!(ThemeData.light());
                              initFunction!.setPrefValue("theme", 0);
                              Navigator.pop(context);
                              setState(() {});
                            },
                          ),
                          RadioListTile<SingingCharacter>(
                            title: const Text('Dark'),
                            value: SingingCharacter.dark,
                            groupValue: character,
                            onChanged: (SingingCharacter? value) {
                              widget.onThemeChangeCallback!(ThemeData.dark());
                              initFunction!.setPrefValue("theme", 0);
                              Navigator.pop(context);
                              setState(() {});
                            },
                          ),
                          RadioListTile<SingingCharacter>(
                            title: const Text('System Default'),
                            value: SingingCharacter.systemDefault,
                            groupValue: character,
                            onChanged: (SingingCharacter? value) {
                              initFunction!.setPrefValue("theme", 2);
                              if (brightness == Brightness.dark) {
                                widget.onThemeChangeCallback!(ThemeData.dark());
                              } else {
                                widget
                                    .onThemeChangeCallback!(ThemeData.light());
                              }
                              Navigator.pop(context);
                              setState(() {});
                            },
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

  void getAppName() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}

typedef OnThemeChangeCallback = Function(ThemeData value);
