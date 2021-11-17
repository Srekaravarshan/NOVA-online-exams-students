import 'package:exam_students/blocs/blocs.dart';
import 'package:exam_students/config/custom_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash';

  static Route route() {
    print("splash route");
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state.status);
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushNamed(AuthScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(NavScreen.routeName);
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
