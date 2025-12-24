import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/notification_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional soft gray
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildBody(context),
        ],
      ),
      floatingActionButton: _buildAnimatedFab(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar.large(
      backgroundColor: Colors.white,
      title: const Text('Global Feed', style: TextStyle(fontWeight: FontWeight.w900)),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () => context.read<NotificationBloc>().add(
            LoadNotifications('d11a01be-9e64-4c42-9884-7ea6e9d69dec'),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return SliverToBoxAdapter(child: _buildSkeletonLoader());
        }
        if (state is NotificationLoaded) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildNotificationCard(state.notifications[index]),
              childCount: state.notifications.length,
            ),
          );
        }
        return const SliverFillRemaining(child: Center(child: Text("Ready to sync.")));
      },
    );
  }

  Widget _buildNotificationCard(dynamic item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.bolt, color: Colors.deepPurple),
          ),
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(item.message, style: TextStyle(color: Colors.grey[600])),
          ),
          trailing: Text("Just now", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(5, (index) => _buildSkeletonCard()),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildAnimatedFab(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.deepPurple,
      icon: const Icon(Icons.add_task_rounded, color: Colors.white),
      label: const Text("New Alert", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      onPressed: () {
        context.read<NotificationBloc>().add(
          TriggerNewNotification(
            'd11a01be-9e64-4c42-9884-7ea6e9d69dec',
            'Industry Level Update',
            'Backend synced with Flutter Web at ${DateTime.now().second}s',
          ),
        );
      },
    );
  }
}