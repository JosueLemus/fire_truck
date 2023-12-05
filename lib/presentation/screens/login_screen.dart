import 'package:bomberman/config/navigation/application_routes.dart';
import 'package:bomberman/config/services/api_services.dart';
import 'package:bomberman/config/services/local_storage_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final apiServices = ApiServices();

  bool isPasswordVisible = false;
  bool isLoading = false;
  bool validEmail = false;
  bool validPassword = false;

  final String welcomeText = '¡Bienvenido de nuevo!';
  final String signInText = 'Por favor, inicia sesión para continuar.';
  final String emailPlaceholder = 'Correo Electrónico';
  final String passwordPlaceholder = 'Contraseña';
  final String forgotPasswordText = '¿Olvidaste tu contraseña?';
  final String loginButtonText = 'Iniciar Sesión';
  final String signUpText = '¿No tienes una cuenta aún?';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> onLoginTap() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();

    try {
      final hash = await apiServices.postLogin(
        emailController.text,
        passwordController.text,
      );

      if (hash.isNotEmpty) {
        await LocalStorageServices.saveLocalData(hash, KeyTypes.userToken);
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await apiServices.postTokenDevice(hash, token);
          // Si todo sale bien
          if (mounted) {
            Navigator.pushNamed(context, Routes.main);
          }
        }
      } else {
        // Si la respuesta de postLogin es vacía
        // Muestra una alerta indicando que la autenticación falló
        if (mounted) {
          CustomDialog.showErrorDialog(
            context,
            "Error de autenticación",
            "Las credenciales son incorrectas.",
          );
        }
      }
    } catch (e) {
      // Si ocurre un error en las solicitudes, muestra una alerta genérica
      if (mounted) {
        CustomDialog.showErrorDialog(
          context,
          "Error",
          "Hubo un problema al procesar tu solicitud.",
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void validateEmail(String email) {
    setState(() {
      validEmail = isValidEmail(email);
    });
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  void validatePassword(String password) {
    setState(() {
      validPassword = password.length >= 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Image.asset(
                      "assets/bomberos_icono_gray.png",
                      width: 150,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      welcomeText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      signInText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      leftIcon: Icons.email,
                      placeholder: emailPlaceholder,
                      controller: emailController,
                      onChanged: validateEmail,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      leftIcon: Icons.lock,
                      placeholder: passwordPlaceholder,
                      isPassword: true,
                      controller: passwordController,
                      onChanged: validatePassword,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(forgotPasswordText),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed:
                            validEmail && validPassword ? onLoginTap : null,
                        child: Text(loginButtonText),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(signUpText),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.main);
                          },
                          child: const Text("Regístrate"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final IconData? leftIcon;
  final bool isPassword;
  final String? placeholder;
  final String? errorText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.leftIcon,
    this.isPassword = false,
    this.placeholder,
    this.errorText,
    this.controller,
    this.onChanged, // Agregado
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && isObscureText,
          onChanged: widget.onChanged, // Pasar onChanged al TextField
          decoration: InputDecoration(
            labelText: widget.placeholder,
            prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon) : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      isObscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                  )
                : null,
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }
}

class CustomDialog {
  static void showErrorDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
