part of 'intro_cubit.dart';

/// Holds the UI state for the intro (onboarding) screen.
///
/// Right now it only tracks one thing: whether the user has reached
/// the last page, so we can swap the "ورق بزن" (Next) button
/// for the "شروع کنید" (Get Started) button.
class IntroState {
  /// `true`  -> user is on the last intro page (show "Get Started")
  /// `false` -> user is on an earlier page (show "Next")
  bool showGetStart;

  IntroState({required this.showGetStart});

  /// Creates a new state based on the current one, changing only the
  /// fields you pass in. Cubits should emit a *new* object instead of
  /// mutating the old one, so the UI knows something changed.
  ///
  /// The `??` operator means: use the new value if it's not null,
  /// otherwise keep the current value.
  IntroState copyWith({
    bool? newShowGetStart,
  }) {
    return IntroState(
      showGetStart: newShowGetStart ?? showGetStart,
    );
  }
}