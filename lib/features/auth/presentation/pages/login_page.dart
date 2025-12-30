import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ✅ Renommé pour correspondre à l'usage de l'Email
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;


    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = "L'email est requis"; 
      });
      hasError = true;
    } else if (!email.contains('@')) {
      setState(() {
        _emailError = "Veuillez entrer un email valide";
      });
      hasError = true;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = AppStrings.passwordRequired;
      });
      hasError = true;
    }

    if (!hasError) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: email, 
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const DashboardPage(),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Z',
                              style: GoogleFonts.poppins(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppStrings.appName,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.appSlogan,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  Text(
                    AppStrings.welcomeBack,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.loginToContinue,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
               
                  CustomTextField(
                    controller: _emailController,
                    label: "Email institutionnel", 
                    hint: 'exemple@zephyr.tn',
                    prefixIcon: Icons.email_outlined, 
                    keyboardType: TextInputType.emailAddress, 
                    errorText: _emailError,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: AppStrings.password,
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: isLoading ? null : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fonctionnalité bientôt disponible'),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(
                          color: AppColors.secondaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                 
                  PrimaryButton(
                    text: AppStrings.login,
                    onPressed: _validateAndLogin,
                    isLoading: isLoading,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}