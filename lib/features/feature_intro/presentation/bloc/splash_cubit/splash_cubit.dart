import 'package:bloc/bloc.dart';
import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/connection_status.dart';
import 'package:shopping/features/feature_intro/repositories/splash_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashRepository splashRepository = SplashRepository();
  SplashCubit() : super(SplashState(connectionStatus: ConnectionInitial()));
  Future<void> checkConnectionEvent() async {
    emit(state.copyWith(newConnectionStatus: ConnectionInitial()));
    bool isConnect = await splashRepository.checkConnectivity();
    if(isConnect){
      emit(state.copyWith(newConnectionStatus: ConnectionOn()));

    }else{
      emit(state.copyWith(newConnectionStatus: ConnectionOff()));
    }
  }
}
