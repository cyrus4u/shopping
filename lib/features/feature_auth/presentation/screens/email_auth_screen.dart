// features/feature_auth/presentation/screens/email_auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping/common/utils/prefs_operator.dart';
import 'package:shopping/common/widgets/dot_loading_widget.dart';
import 'package:shopping/common/widgets/main_wrapper.dart';
import 'package:shopping/features/feature_auth/presentation/bloc/login_bloc/bloc/login_bloc.dart';
import 'package:shopping/features/feature_auth/presentation/widgets/auth_widgets.dart';
import 'package:shopping/features/feature_auth/presentation/widgets/custom_clippath_signup.dart';
import 'package:shopping/locator.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailAuthScreen extends StatefulWidget {
  static const routeName = '/email_auth_screen';
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  StreamSubscription<AuthState>? _authSub;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn && !_navigated && mounted) {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainWrapper.routeName,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  /// false = step 1 (enter email), true = step 2 (enter code)
  bool _codeSent = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final bloc = context.read<LoginBloc>();
    final email = _emailController.text.trim();

    if (!_codeSent) {
      bloc.add(LoadSendEmailCode(email));
    } else {
      bloc.add(LoadVerifyEmailCode(email, _codeController.text.trim()));
    }
  }

  void _changeEmail() {
    setState(() => _codeSent = false);
    _codeController.clear();
  }

  Future<void> _pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final digits = (data?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 6) {
      _codeController.text = digits.substring(0, 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: MultiBlocListener(
            listeners: [
              // Step 1 result
              BlocListener<LoginBloc, LoginState>(
                listenWhen: (p, c) => p.loginDataStatus != c.loginDataStatus,
                listener: (context, state) {
                  final status = state.loginDataStatus;
                  if (status is LoginDataError) {
                    showAuthSnack(context, status.errorMessage, Colors.red);
                  }
                  if (status is LoginDataCompleted) {
                    setState(() => _codeSent = true);
                    showAuthSnack(
                      context,
                      'کد ورود به ایمیل شما ارسال شد',
                      Colors.green,
                    );
                  }
                },
              ),
              // Step 2 result
              BlocListener<LoginBloc, LoginState>(
                listenWhen: (p, c) => p.codeCheckStatus != c.codeCheckStatus,
                listener: (context, state) {
                  final status = state.codeCheckStatus;
                  if (status is CodeCheckError) {
                    showAuthSnack(context, status.errorMessage, Colors.red);
                  }
                  if (status is CodeCheckCompleted) {
                    _navigated = true;  
                    final user = status.user;
                    showAuthSnack(
                      context,
                      '${user.displayName} به نیاز خوش آمدید',
                      Colors.green,
                    );

                    // TEMPORARY bridge for code that still reads SharedPreferences.
                    locator<PrefsOperator>().saveUserData(
                      user.accessToken ?? '',
                      user.displayName,
                      user.email,
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MainWrapper.routeName,
                      (route) => false,
                    );
                  }
                },
              ),
            ],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: CustomClipPathSignUp(),
                    child: Container(
                      width: width,
                      height: height * 0.3,
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.white,
                                  highlightColor: Colors.grey,
                                  child: const Text(
                                    'ورود / ثبت نام',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Vazir',
                                    ),
                                  ),
                                ),
                                Text(
                                  'فروشگاه ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Vazir',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Step 1 field (stays visible, locked once the code is sent)
                          IgnorePointer(
                            ignoring: _codeSent,
                            child: Opacity(
                              opacity: _codeSent ? 0.6 : 1,
                              child: AuthTextField(
                                label: 'ایمیل',
                                controller: _emailController,
                                validator: AuthValidators.email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.email],
                                isLtr: true,
                                onSubmitted: _submit,
                              ),
                            ),
                          ),

                          // Step 2 field
                          if (_codeSent) ...[
                            const SizedBox(height: 16),
                            AuthTextField(
                              label: 'کد ورود',
                              controller: _codeController,
                              validator: (v) => (v?.trim().length ?? 0) < 6
                                  ? 'کد را کامل وارد کنید'
                                  : null,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              isLtr: true,
                              onSubmitted: _submit,
                              suffix: IconButton(
                                icon: const Icon(Icons.content_paste),
                                tooltip: 'چسباندن',
                                onPressed: _pasteCode,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),

                          // Main button
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (p, c) =>
                                p.loginDataStatus != c.loginDataStatus ||
                                p.codeCheckStatus != c.codeCheckStatus,
                            builder: (context, state) {
                              final loading =
                                  state.loginDataStatus is LoginDataLoading ||
                                  state.codeCheckStatus is CodeCheckLoading;
                              if (loading) {
                                return const Center(
                                  child: DotLoadingWidget(size: 30),
                                );
                              }
                              return SizedBox(
                                width: width,
                                height: 58,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _submit,
                                  child: Text(
                                    _codeSent ? 'ورود' : 'ارسال کد ورود',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Vazir',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          if (_codeSent)
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: _changeEmail,
                                child: const Text(
                                  'تغییر ایمیل / ارسال مجدد کد',
                                  style: TextStyle(fontFamily: 'Vazir'),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'یا',
                                  style: TextStyle(fontFamily: 'Vazir'),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Google (Part B)
                          SizedBox(
                            width: width,
                            height: 58,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => context.read<LoginBloc>().add(
                                LoadGoogleSignIn(),
                              ),
                              icon: const Icon(Icons.g_mobiledata, size: 32),
                              label: const Text(
                                'ادامه با گوگل',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Vazir',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
