import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiny_thinker_sort/main.dart';
import 'package:tiny_thinker_sort/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SortJoy shows onboarding for new users', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.load();

    await tester.pumpWidget(SortJoyApp(appState: appState));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('SortJoy'), findsOneWidget);
    expect(find.text('Let’s Sort!'), findsOneWidget);
    expect(find.text('Tiny Learners'), findsOneWidget);
  });
}
