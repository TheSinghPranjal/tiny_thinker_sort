import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/repositories/asset_game_content_repository.dart';
import 'presentation/providers/game_library.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';
import 'theme/sortjoy_theme.dart';
import 'widgets/app_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final library = GameLibrary(await AssetGameContentRepository.load());
  final appState = AppState();
  await appState.load(library: library);
  runApp(SortJoyApp(appState: appState, library: library));
}

class SortJoyApp extends StatelessWidget {
  const SortJoyApp({super.key, required this.appState, required this.library});

  final AppState appState;
  final GameLibrary library;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        Provider<GameLibrary>.value(value: library),
      ],
      child: MaterialApp(
        title: 'SortJoy',
        debugShowCheckedModeBanner: false,
        theme: SortJoyTheme.light(),
        home: Consumer<AppState>(
          builder: (context, state, _) {
            if (!state.ready) {
              return const Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppBackground(),
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            }
            if (!state.onboarded || state.ageWorld == null) {
              return const OnboardingScreen();
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
