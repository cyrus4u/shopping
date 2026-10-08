import 'package:bloc/bloc.dart';

/// Manages the selected tab index of the bottom navigation bar.
class BottomNavCubit extends Cubit<int> {
  /// Starts on the first tab.
  BottomNavCubit() : super(0);

  /// Switches to the tab at [index].
  void changeSelectedIndex(int index) => emit(index);
}