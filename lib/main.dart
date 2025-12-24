import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_portal/core/network/app_client.dart';
import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/notifications/presentation/pages/notification_page.dart';

void main() {
  // 1. Initialize Core Client (Shared across features)
  final apiClient = ApiClient();
  
  // 2. Wrap the app in the BLoC dependency tree
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(apiClient),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaaS Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Providing the Bloc to the NotificationPage feature
      home: BlocProvider(
        create: (context) => NotificationBloc(
          context.read<NotificationRepository>(),
        )..add( LoadNotifications('d11a01be-9e64-4c42-9884-7ea6e9d69dec')),
        child: const NotificationPage(),
      ),
    );
  }
}