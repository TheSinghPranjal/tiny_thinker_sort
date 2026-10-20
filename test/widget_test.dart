import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiny_thinker_sort/data/repositories/asset_game_content_repository.dart';
import 'package:tiny_thinker_sort/main.dart';
import 'package:tiny_thinker_sort/presentation/providers/game_library.dart';
import 'package:tiny_thinker_sort/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SortJoy shows onboarding for new users', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final library = GameLibrary(await AssetGameContentRepository.load());
    final appState = AppState();
    await appState.load(library: library);

    await tester.pumpWidget(SortJoyApp(appState: appState, library: library));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('SortJoy'), findsOneWidget);
    expect(find.text('Let’s Sort!'), findsOneWidget);
    expect(find.text('Tiny Learners'), findsOneWidget);
  });
}
