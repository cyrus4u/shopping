import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

// Links this file with intro_state.dart so both share the same library
// and IntroState can stay "private" to the cubit's feature.
part 'intro_state.dart';

/// Manages the state of the intro screen.
/// A Cubit is a simpler version of a Bloc: it uses plain methods
/// instead of events.
class IntroCubit extends Cubit<IntroState> {
  /// Initial state: the "Get Started" button is hidden,
  /// because the user always starts on the first page.
  IntroCubit() : super(IntroState(showGetStart: false));

  /// Called from the PageView's `onPageChanged`.
  /// Pass `true` when the last page is visible, `false` otherwise.
  /// `emit` publishes a new state, and any BlocBuilder listening
  /// to this cubit rebuilds automatically.
  void changeGetStart(bool value) =>
      emit(state.copyWith(newShowGetStart: value));
}