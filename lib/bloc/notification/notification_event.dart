
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NotificationEvent extends Equatable {}

@immutable
class GotMessageOnForeground extends NotificationEvent {
  final RemoteMessage remoteMessage;

  GotMessageOnForeground(this.remoteMessage);

  @override
  List<Object?> get props => [remoteMessage];
}

@immutable
class RequestNotificationPermission extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

@immutable
class ListeningNotification extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

@immutable
class FetchNotification extends NotificationEvent {
  @override
  List<Object?> get props => [];
}
