import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_event.dart';
import 'notification_state.dart';

import '../../repository/notification_repository/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepo;
  late StreamSubscription<RemoteMessage> _onMessageSubscription;

  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepo = notificationRepository,
        super(NotificationState.initial()) {
    on<FetchNotification>(_fetchNotifications);
    on<NotificationEvent>(_onFirebaseNotificationEvent);
    add(RequestNotificationPermission());
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      Map<String, dynamic> data = event.data;
      String title = data['title'];
      String body = data['body'];
      _notificationRepo.showNotification(id: 0, title: title, body: body);
    });
  }

  @override
  Future<void> close() {
    _onMessageSubscription.cancel();
    return super.close();
  }

  void _onFirebaseNotificationEvent(
      NotificationEvent event, Emitter<NotificationState> emit) {
    if (event is RequestNotificationPermission) {
      _requestNotificationService();
    }
  }

  @override
  void onChange(Change<NotificationState> change) {
    super.onChange(change);
  }

  void _requestNotificationService() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  _fetchNotifications(event, emit) async {
    var notifications =await _notificationRepo.getNotifications();
    emit(state.copyWith(notifications: notifications));
  }
}
