import 'package:flutter/material.dart';
import 'package:jivosdk_plugin/bridge.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'JivoSDK Flutter Demo',
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: TextButton(
        onPressed: () async {
          await _setupJivo();
        },
        child: const Text('Chat'),
      ),
    );
  }

  Future<void> _setupJivo() async {
    // Notes:
    // - Push notifications not implemented

    // await Jivo.session.setContactInfo( // issue: https://github.com/JivoChat/JivoSDK-FlutterDemo/issues/7
    //   name: 'test intervale',
    //   phone: '+7 495 937 99 92',
    //   email: 'misha.potapych@intervale.ru',
    //   brief: 'here is some bried',
    // );

    await Jivo.session.setContactInfo( // issue: https://github.com/JivoChat/JivoSDK-FlutterDemo/issues/8
      name: 'Homer',
      email: 'h.simpson@springfield.com',
      phone: 'Simpson',
      brief: 'Family guy',
    );

    await Jivo.session.setup(channelId: '', userToken: '');
    await Jivo.display.present();
  }
}
