import 'package:get/get.dart';

import '../global.dart';

class Routes {
  static const String splash = "/splash";
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String registration = "/registration";

  static List<GetPage> pages = [
    GetPage(
        name: Routes.splash,
        page: () => const SplashScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.welcome,
        page: () => WelcomeScreen(),
        transition: Transition.noTransition),
    GetPage(name: Routes.login, page: () => SignInScreen()),
    GetPage(name: Routes.registration, page: () => SignUpScreen()),
  ];
}
