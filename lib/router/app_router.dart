import 'package:go_router/go_router.dart';

import '/screens/app_screens.dart';

final appRouter = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/main_page/:code/:player',
    builder: (context, state) => const MainPage(),
  ),
]);
