import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  /* static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  } */

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Splash Page')),
    );
  }
}
