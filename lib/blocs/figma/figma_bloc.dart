import 'package:bloc/bloc.dart';
import 'package:l10n_manipulator/database/database.dart';
import 'package:l10n_manipulator/repositories/database_repository.dart';
import 'package:meta/meta.dart';

part 'figma_event.dart';

part 'figma_state.dart';

class FigmaBloc extends Bloc<FigmaEvent, FigmaState> {
  FigmaBloc() : super(FigmaState()) {
    on<UserSetApiKeyEvent>(_onUserSetApiKey);
    on<FirstLoadApiKeyEvent>(_onLoadApiKey);
    add(FirstLoadApiKeyEvent());
  }

  _onUserSetApiKey(
    UserSetApiKeyEvent event,
    Emitter<FigmaState> emit,
  ) {
    emit(state.setApiKey(event.apiKey));
  }

  _onLoadApiKey(
    FirstLoadApiKeyEvent event,
    Emitter<FigmaState> emit,
  ) {
    // emit(FigmaState(figma: DatabaseRepository.instance));
  }
}
