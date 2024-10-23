import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_frontend/providers/authProvider.dart';
import 'package:user_frontend/screens/aboutMe/main.dart';
import 'package:user_frontend/screens/activity/changeSchedule.dart';
import 'package:user_frontend/screens/booking/detailBooking.dart';
import 'package:user_frontend/screens/booking/main.dart';
import 'package:user_frontend/screens/checkout.dart';
import 'package:user_frontend/screens/help/main.dart';
import 'package:user_frontend/screens/information/detail-notification.dart';
import 'package:user_frontend/screens/information/main.dart';
import 'package:user_frontend/screens/login.dart';
import 'package:user_frontend/screens/menuNavigation.dart';
import 'package:user_frontend/screens/membership/main.dart';
import 'package:user_frontend/screens/profile/form.dart';
import 'package:user_frontend/screens/register.dart';
import 'package:user_frontend/screens/splash.dart';
import 'package:user_frontend/screens/viewSchedule/main.dart';

// Auth Guard Widget
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAuthenticated) {
      return const LoginPage();
    }
    return child;
  }
}

// Route generator
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/splashScreen':
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case '/register':
      return MaterialPageRoute(builder: (_) => const RegisterPage());
    case '/home':
      return MaterialPageRoute(
          builder: (_) =>
              const AuthGuard(child: MenuNavigation(initialIndex: 0)));
    case '/activity':
      return MaterialPageRoute(
          builder: (_) =>
              const AuthGuard(child: MenuNavigation(initialIndex: 1)));
    case '/profile':
      return MaterialPageRoute(
          builder: (_) =>
              const AuthGuard(child: MenuNavigation(initialIndex: 2)));
    case '/form':
      return MaterialPageRoute(
          builder: (context) => const AuthGuard(child: FormEditProfile()),
          settings: settings);
    case '/information':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: InformationPage()));
    case '/detailInfo':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: DetailNotification()),
          settings: settings);
    case '/booking':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: BookingFieldPage()));
    case '/detailBook':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: DetailBookingPage()),
          settings: settings);
    case '/checkout':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: CheckoutPage()),
          settings: settings);
    case '/help':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: HelpPage()));
    case '/viewSchedule':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: ViewSchedulePage()));
    case '/aboutMe':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AboutMe()));
    case '/membership':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: MembershipPage()));
    case '/changeSchedule':
      return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: ChangeSchedule()),
          settings: settings);
    default:
      return MaterialPageRoute(builder: (_) => const LoginPage());
  }
}
