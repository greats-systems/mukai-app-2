import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/auth/views/login.dart';
import 'package:mukai/src/apps/auth/views/otp.dart';
import 'package:mukai/src/bottom_bar.dart';
// import 'package:mukai/src/splash.dart';
import 'package:get/get.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static String get initialRoute {
    final authController = Get.put(AuthController());
    return authController.isSessionLogged.value ? bottomBar : login;
  }

  // static const initial = Routes.splash;
  static const bottomBar = Routes.bottomBar;
  static const login = Routes.login;

  static final routes = [
    // GetPage(name: _Paths.splash, page: () => const SplashScreen()),
    GetPage(name: _Paths.login, page: () => LoginScreen()),
    GetPage(name: _Paths.otp, page: () => OTPScreen()),

    // GetPage(name: _Paths.register, page: () => RegisterScreen()),
    GetPage(name: _Paths.home, page: () => const BottomBar()),
    // GetPage(name: _Paths.login, page: () => LoginScreen()),
    // GetPage(name: _Paths.register, page: () => RegisterScreen()),
    GetPage(name: _Paths.bottomBar, page: () => const BottomBar()),
    // GetPage(name: _Paths.profile, page: () => const ProfileScreen()),
    // GetPage(name: _Paths.editProfile, page: () => const EditProfileScreen()),
  ];
}
