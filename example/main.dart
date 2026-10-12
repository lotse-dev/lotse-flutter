import 'package:flutter/material.dart';
import 'package:lotse/lotse.dart';

/// A minimal app on Lotse: a deferred link, an event and the feedback sheet.
///
/// Replace the public key and the server URL with the ones of your project in
/// the Lotse console.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Lotse.captureLaunchLinks(); // before the first await
  await Lotse.init(publicKey: 'lt_pk_...', serverUrl: 'https://api.lotse.dev/');

  // Set on the first start after an install that came from a link.
  final link = await Lotse.instance.deferredLink;
  runApp(LotseScope(child: ExampleApp(initialPath: link?.targetPath)));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key, this.initialPath});

  final String? initialPath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [LotseScreenObserver()],
      home: HomeScreen(initialPath: initialPath),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.initialPath});

  final String? initialPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lotse example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Opened from link: ${initialPath ?? 'none'}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Lotse.instance.track(
                'checkout_started',
                props: {'cart': '3 items'},
              ),
              child: const Text('Track an event'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Lotse.instance.showFeedback(context),
              child: const Text('Send feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
