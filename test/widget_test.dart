import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:safeleaf/modules/auth/binding/pin_setup_binding.dart';
import 'package:safeleaf/modules/auth/view/pin_setup_view.dart';

void main() {
  testWidgets('PIN setup screen renders first step', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialBinding: PinSetupBinding(),
        home: const PinSetupView(),
      ),
    );

    expect(find.text('Create your PIN'), findsOneWidget);
    expect(find.text('Step 1 of 2'), findsOneWidget);
  });
}
