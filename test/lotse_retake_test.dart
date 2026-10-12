import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_retake.dart';

late BuildContext _context;

LotseRetakeRequest _request() => LotseRetakeRequest(
  hint: 'hint',
  captureLabel: 'capture',
  cancelLabel: 'cancel',
  themes: InheritedTheme.capture(from: _context, to: null),
  textDirection: TextDirection.ltr,
);

void main() {
  setUpAll(() {
    // Any element will do: the requests only carry the themes around.
    _context = _RootElement();
  });

  group('Given a retake controller', () {
    test('when the user answers then the request completes with the choice '
        'and the bar is gone', () async {
      final controller = LotseRetakeController();
      final answer = controller.request(_request());
      expect(controller.current.value, isNotNull);

      controller.answer(LotseRetakeChoice.capture);

      expect(await answer, LotseRetakeChoice.capture);
      expect(controller.current.value, isNull);
      controller.dispose();
    });

    test('when a second request comes then the first completes with null and '
        'the bar shows the second', () async {
      final controller = LotseRetakeController();
      final first = controller.request(_request());
      final secondRequest = _request();
      final second = controller.request(secondRequest);

      expect(await first, isNull);
      expect(controller.current.value, same(secondRequest));

      controller.answer(LotseRetakeChoice.cancel);
      expect(await second, LotseRetakeChoice.cancel);
      controller.dispose();
    });

    test(
      'when the scope goes away then an open request completes with null',
      () async {
        final controller = LotseRetakeController();
        final answer = controller.request(_request());

        controller.dispose();

        expect(await answer, isNull);
      },
    );

    test('when nothing is open then an answer does nothing', () {
      final controller = LotseRetakeController()
        ..answer(LotseRetakeChoice.capture);
      expect(controller.current.value, isNull);
      controller.dispose();
    });
  });
}

class _RootElement extends StatelessElement {
  _RootElement() : super(const _Nothing());

  @override
  void visitAncestorElements(ConditionalElementVisitor visitor) {}
}

class _Nothing extends StatelessWidget {
  const _Nothing();

  @override
  Widget build(BuildContext context) => const SizedBox();
}
