

import 'package:shopping/features/feature_intro/presentation/bloc/splash_cubit/connection_status.dart';

class SplashState {
  ConnectionStatus connectionStatus;
  SplashState({required this.connectionStatus});
  
  SplashState copyWith({ConnectionStatus? newConnectionStatus}) {
    return SplashState(
      connectionStatus: newConnectionStatus ?? connectionStatus,
    );
  }
}
