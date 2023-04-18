part of 'figma_bloc.dart';

@immutable
class FigmaEvent {}

class UserSetApiKeyEvent extends FigmaEvent {
  final String apiKey;

  UserSetApiKeyEvent(this.apiKey) : super();
}

class FirstLoadApiKeyEvent extends FigmaEvent {}
