part of 'fcm_bloc.dart';

abstract class FcmEvent extends Equatable {
  const FcmEvent();

  @override
  List<Object> get props => [];
}

class UpdateFcmTokenEvent extends FcmEvent {
  const UpdateFcmTokenEvent(this.fcmToken);

  final String fcmToken;

  @override
  List<Object> get props => [fcmToken];
}
