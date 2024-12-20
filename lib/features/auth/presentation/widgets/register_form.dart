import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:todo_app/features/auth/presentation/bloc/user_manager/user_manager_bloc.dart';
import 'package:todo_app/features/auth/presentation/widgets/auth_btn.dart';
import 'package:validators/validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color inputBorderColor = theme.brightness == Brightness.light
        ? Colors.purple.shade700
        : Colors.deepPurple.shade900;

    Color iconColor = theme.brightness == Brightness.light
        ? Colors.purple.shade700
        : Colors.deepPurple.shade900;

    Color buttonColor = theme.brightness == Brightness.light
        ? Colors.purple.shade700
        : Colors.deepPurple.shade900;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: "Enter your name",
            icon: Icons.person,
            iconColor: iconColor,
            borderColor: inputBorderColor,
            validator: (value) =>
                value == null || value.isEmpty ? "Name is required" : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: "Enter your email",
            icon: Icons.email,
            iconColor: iconColor,
            borderColor: inputBorderColor,
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!isEmail(value)) return "Invalid email format";
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _pwdController,
            label: "Enter your password",
            icon: Icons.lock,
            iconColor: iconColor,
            borderColor: inputBorderColor,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return "Password is required";
              if (!isLength(value, 8)) return "Password must be at least 8 characters long";
              return null;
            },
          ),
          const SizedBox(height: 30),
          BlocBuilder<UserManagerBloc, UserManagerState>(
            builder: (context, state) {
              if (state is RegisteringUserState) {
                return const CircularProgressIndicator(
                  color: Colors.green,
                );
              } else {
                return AuthButton(
                  text: "Register",
                  onPressed: validateAndRegisterUser,
                  color: buttonColor,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color? iconColor,
    Color? borderColor,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor ?? Colors.grey),
        ),
      ),
    );
  }

  void validateAndRegisterUser() {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
        name: _nameController.text,
        email: _emailController.text,
        password: _pwdController.text,
      );

      BlocProvider.of<UserManagerBloc>(context).add(RegisterEvent(user: user));
    }
  }
}
