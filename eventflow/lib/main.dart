import 'package:eventflow/screens/auth/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/providers/auth_provider.dart';
import 'package:eventflow/providers/my_events_provider.dart';
import 'package:eventflow/providers/tickets_provider.dart';
import 'package:eventflow/providers/favorites_provider.dart';
import 'package:eventflow/screens/create_event.dart';
import 'mainscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => MyEventsProvider()),
        ChangeNotifierProvider(create: (_) => TicketsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class AuthEventUpdater {
  static void updateUserEvents(BuildContext context, String? email) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.updateUserEvents(email);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {'/create_event': (context) => const CreateEventScreen()},
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Set context for AuthProvider after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setContext(context);

      // Load favorites and tickets when user is authenticated
      if (authProvider.isAuthenticated) {
        final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
        final ticketsProvider = Provider.of<TicketsProvider>(context, listen: false);
        favoritesProvider.loadFavorites();
        ticketsProvider.loadTickets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking authentication
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Navigate to appropriate screen based on authentication status
        if (authProvider.isAuthenticated) {
          return MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
