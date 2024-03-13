import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ThemeMode currentTheme = ThemeMode.light;

class ChangeAppTheme extends StatefulWidget {
  final OnThemeChangeCallback? onThemeChangeCallback;
  const ChangeAppTheme({super.key, required this.onThemeChangeCallback});

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
        if (value && brightness == Brightness.light) {
          widget.onThemeChangeCallback!(ThemeData.dark());
        } else {
          widget.onThemeChangeCallback!(ThemeData.light());
        }
        isChange = value;
        setState(() {});
      },
    );
  }
}

typedef OnThemeChangeCallback = Function(ThemeData value);
