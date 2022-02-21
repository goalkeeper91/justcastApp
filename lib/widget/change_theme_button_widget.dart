import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justcast_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark ? 'DarkMode' : 'LightMode';

    return SwitchListTile.adaptive(
      value: themeProvider.isDarkMode,
      title: Text(text),
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}