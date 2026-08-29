import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volttrack/app.dart';

void main() {
  testWidgets('底部导航四个页签可切换', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('概览'), findsWidgets);
    await tester.tap(find.text('统计'));
    await tester.pumpAndSettle();
    expect(find.text('统计页'), findsOneWidget);
  });
}