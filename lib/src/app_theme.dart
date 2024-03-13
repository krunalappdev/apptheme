import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ThemeMode currentTheme = ThemeMode.light;

class ChangeAppTheme extends StatefulWidget {
  final OnThemeChangeCallback? onThemeChangeCallback;
  const ChangeAppTheme({super.key, this.onThemeChangeCallback});

  @override
  State<ChangeAppTheme> createState() => _ChangeAppThemeState();
}

class _ChangeAppThemeState extends State<ChangeAppTheme> {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isChange = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isChange,
      onChanged: (value) {
        widget.onThemeChangeCallback!(value);
        if (value && brightness == Brightness.light) {
          setCurrentTheme(ThemeMode.dark);
        } else {
          setCurrentTheme(ThemeMode.light);
        }
      },
    );
  }

  void setCurrentTheme(ThemeMode theme) {
    currentTheme = theme;
    isChange = !isChange;
    setState(() {});
  }
}

typedef OnThemeChangeCallback = Function(bool value);
