import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

ThemeMode currentTheme = ThemeMode.light;

class ChangeAppTheme extends StatefulWidget {
  const ChangeAppTheme({super.key});

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
