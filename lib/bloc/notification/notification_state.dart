
import '../../models/Notification_resp.dart';

class NotificationState {
  final List<NotificationResp> notifications;

  const NotificationState._({this.notifications = const []});

  const NotificationState.initial() : this._();

  NotificationState copyWith({List<NotificationResp>? notifications}) {
    return NotificationState._(
        notifications: notifications ?? this.notifications);
  }
}
