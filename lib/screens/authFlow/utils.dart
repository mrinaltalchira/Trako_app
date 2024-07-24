import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../color/colors.dart';


class IntlPhoneInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onPhoneNumberChanged;

  const IntlPhoneInputTextField({
    super.key,
    required this.controller,
    required this.onPhoneNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,

      decoration: InputDecoration(
        counterText: "",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: colorMixGrad, // Example focused border color
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: '|  Phone number',
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
      ),
      initialCountryCode: 'IN', // Example initial country code
      onChanged: (phone) {
        // Get the full phone number with country code
        final fullPhoneNumber = '${phone.countryCode} ${phone.number}';
        onPhoneNumberChanged(fullPhoneNumber);
      },
      showCountryFlag: true,
      showDropdownIcon: false,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),

      dropdownTextStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class PasswordInputTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInputTextField({super.key, required this.controller});

  @override
  _PasswordInputTextFieldState createState() => _PasswordInputTextFieldState();
}

class _PasswordInputTextFieldState extends State<PasswordInputTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
          BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0), // Removed const from EdgeInsets
      ),
      obscureText: _obscureText,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}

class EmailInputTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailInputTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
          BorderSide(color: colorMixGrad), // Border color when focused
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}
