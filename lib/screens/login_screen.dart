import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons; // solo para el icono de birrete

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/dialogs.dart';
import '../widgets/fade_slide_in.dart';

/// 1. LOGIN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _ocultar = true;
  bool _cargando = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      return showInfoDialog(context,
          titulo: 'Campos incompletos',
          mensaje: 'Ingresa tu email y contraseña.');
    }
    if (!email.contains('@')) {
      return showInfoDialog(context,
          titulo: 'Email inválido', mensaje: 'Revisa el formato del email.');
    }

    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 900)); // simula servidor
    if (!mounted) return;
    setState(() => _cargando = false);
    Navigator.pushReplacementNamed(context, AppRoutes.menu);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo con animación de "rebote"
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.4, end: 1),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.elasticOut,
                    builder: (context, escala, child) =>
                        Transform.scale(scale: escala, child: child),
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school,
                          size: 62, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const FadeSlideIn(
                  delay: Duration(milliseconds: 100),
                  child: Text(
                    'Iniciar Sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 6),
                const FadeSlideIn(
                  delay: Duration(milliseconds: 160),
                  child: Text(
                    'Ingresa tus credenciales para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 220),
                  child: AppTextField(
                    controller: _emailCtrl,
                    placeholder: 'Email',
                    prefixIcon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 14),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 280),
                  child: AppTextField(
                    controller: _passCtrl,
                    placeholder: 'Password',
                    prefixIcon: CupertinoIcons.lock,
                    obscureText: _ocultar,
                    onSubmitted: (_) => _login(),
                    suffix: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: () => setState(() => _ocultar = !_ocultar),
                      child: Icon(
                        _ocultar ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 340),
                  child: CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(10),
                    onPressed: _cargando ? null : _login,
                    child: _cargando
                        ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white)
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  child: CupertinoButton(
                    onPressed: () => showInfoDialog(
                      context,
                      titulo: 'Recuperar contraseña',
                      mensaje:
                          'Te enviaremos un enlace a tu correo para restablecerla.',
                    ),
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
