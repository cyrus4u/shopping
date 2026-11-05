// lib/common/utils/start_route.dart
import 'package:shopping/common/widgets/main_wrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shopping/features/feature_auth/presentation/screens/email_auth_screen.dart';


/// Where to go once the intro is finished (or skipped).
/// Supabase restores the saved session inside Supabase.initialize(),
/// so currentSession is already available here (no async work needed).
// start_route.dart

String routeAfterIntro() {
  final loggedIn = Supabase.instance.client.auth.currentSession != null;
  return loggedIn ? MainWrapper.routeName : EmailAuthScreen.routeName;
}