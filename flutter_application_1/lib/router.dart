import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_admin.dart';
import 'pages/dashboard_kasir.dart';
import 'pages/payment_page.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/dashboard_admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/dashboard_kasir',
      builder: (context, state) => const KasirDashboard(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return PaymentPage(
          cart: args['cart'],
          totalPrice: args['totalPrice'],
        );
      },
    ),
  ],
);
