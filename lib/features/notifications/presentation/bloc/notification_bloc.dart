import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/models/notification_model.dart';

// Events
abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;
  LoadNotifications(this.userId);
}

// States
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

// 1. Add the Event
class TriggerNewNotification extends NotificationEvent {
  final String userId;
  final String title;
  final String message;
  TriggerNewNotification(this.userId, this.title, this.message);
}

// Bloc Logic
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final data = await repository.fetchHistory(event.userId);
        emit(NotificationLoaded(data));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    // 2. Add the Logic in the Bloc Constructor
    on<TriggerNewNotification>((event, emit) async {
      try {
        // Send the notification to the backend
        await repository.sendNotification(
          userId: event.userId,
          title: event.title,
          message: event.message,
        );

        // Automatically trigger a refresh to update the list
        add(LoadNotifications(event.userId));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}
