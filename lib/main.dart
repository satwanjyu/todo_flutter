import 'package:animations/animations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_flutter/pages/home/home_api.dart';
import 'package:todo_flutter/repository/task_repository.dart';

import 'db.dart';
import 'pages/home/home.dart';

void main() {
  runApp(
    MyApp(
      home: HomePage(
        api: HomeApi(
          taskRepository: TaskRepository(
            localDB: LocalDB.getInstance(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.home});

  final Widget home;

  static const _m3DefaultSeedColor = Color(0xff6750a4);

  static final _fallbackLightScheme = ColorScheme.fromSeed(
    seedColor: _m3DefaultSeedColor,
    brightness: Brightness.light,
  );

  static final _fallbackDarkScheme = ColorScheme.fromSeed(
    seedColor: _m3DefaultSeedColor,
    brightness: Brightness.dark,
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    border: UnderlineInputBorder(),
  );

  static const _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  );

  static const _sharedAxisPageTransitionsBuilder =
      SharedAxisPageTransitionsBuilder(
    transitionType: SharedAxisTransitionType.horizontal,
  );

  static const _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _sharedAxisPageTransitionsBuilder,
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: _sharedAxisPageTransitionsBuilder,
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: _sharedAxisPageTransitionsBuilder,
    },
  );

  static _tooltipThemeData(ColorScheme scheme) => TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        textStyle: TextStyle(
          color: scheme.onSecondaryContainer,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightScheme, darkScheme) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: lightScheme ?? _fallbackLightScheme,
          useMaterial3: true,
          inputDecorationTheme: _inputDecorationTheme,
          snackBarTheme: _snackBarTheme,
          pageTransitionsTheme: _pageTransitionsTheme,
          tooltipTheme: _tooltipThemeData(lightScheme ?? _fallbackLightScheme),
        ),
        darkTheme: ThemeData(
          colorScheme: darkScheme ?? _fallbackDarkScheme,
          useMaterial3: true,
          inputDecorationTheme: _inputDecorationTheme,
          snackBarTheme: _snackBarTheme,
          pageTransitionsTheme: _pageTransitionsTheme,
          tooltipTheme: _tooltipThemeData(darkScheme ?? _fallbackDarkScheme),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        home: home,
      );
    });
  }
}
