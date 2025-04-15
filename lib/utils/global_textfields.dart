import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Trako/color/colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

enum TextFieldType {
  text,
  name,
  email,
  password,
  phone,
  intlPhone, // New field type for international phone input
  multiline,
  number,
  date,
  city,
  address
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextFieldType fieldType;
  final int? maxLength;
  final int maxLines;
  final bool isOptional;
  final bool autofocus;
  final bool enabled;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? additionalFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final Color? fillColor;
  final bool filled;
  final Function()? onTap;
  final AutovalidateMode autovalidateMode;
  final String initialCountryCode; // New parameter for intlPhone
  final bool showCountryFlag; // New parameter for intlPhone
  final bool showDropdownIcon; // New parameter for intlPhone
  final TextStyle? dropdownTextStyle; // New parameter for intlPhone
  final String? Function(PhoneNumber?)? phoneValidator; // Specific validator for IntlPhoneField

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.fieldType = TextFieldType.text,
    this.maxLength,
    this.maxLines = 1,
    this.isOptional = false,
    this.autofocus = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.focusNode,
    this.additionalFormatters,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.fillColor,
    this.filled = false,
    this.onTap,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.initialCountryCode = 'IN', // Default value
    this.showCountryFlag = true, // Default value
    this.showDropdownIcon = false, // Default value
    this.dropdownTextStyle, // For intlPhone
    this.phoneValidator, // For intlPhone
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _phoneRegex = RegExp(r'^\d{7,15}$');

  @override
  Widget build(BuildContext context) {
    // Handle IntlPhoneField separately
    if (widget.fieldType == TextFieldType.intlPhone) {
      return _buildIntlPhoneField();
    }

    // Regular TextField
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.fieldType == TextFieldType.password ? _obscureText : false,
      maxLength: widget.maxLength ?? _getDefaultMaxLength(),
      maxLines: widget.fieldType == TextFieldType.password ? 1 : widget.maxLines,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      style: widget.textStyle ?? TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      inputFormatters: _getInputFormatters(),
      validator: widget.validator ?? _getDefaultValidator(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.isOptional ? '${widget.hintText} (optional)' : widget.hintText,
        counterText: '',
        hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey),
        prefixIcon: widget.prefixIcon ?? _getDefaultPrefixIcon(),
        suffixIcon: widget.suffixIcon ?? _getPasswordToggle(),
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: widget.border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: widget.focusedBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorMixGrad),
        ),
        enabledBorder: widget.enabledBorder,
        filled: widget.filled,
        fillColor: widget.fillColor,
      ),
    );
  }

  // New method to build IntlPhoneField
  Widget _buildIntlPhoneField() {
    return IntlPhoneField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        counterText: "",
        hintText: widget.isOptional ? '${widget.hintText} (optional)' : widget.hintText,
        hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey),
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: widget.border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: widget.focusedBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorMixGrad),
        ),
        enabledBorder: widget.enabledBorder,
        filled: widget.filled,
        fillColor: widget.fillColor,
      ),
      initialCountryCode: widget.initialCountryCode,
      onChanged: (phone) {
        // Get the full phone number with country code
        final fullPhoneNumber = '${phone.countryCode} ${phone.number}';
        if (widget.onChanged != null) {
          widget.onChanged!(fullPhoneNumber);
        }
      },
      showCountryFlag: widget.showCountryFlag,
      showDropdownIcon: widget.showDropdownIcon,
      style: widget.textStyle ?? TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      dropdownTextStyle: widget.dropdownTextStyle ?? TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      autovalidateMode: widget.autovalidateMode,
      validator: widget.phoneValidator ?? _getDefaultPhoneValidator(),
      enabled: widget.enabled,
      autofocus: widget.autofocus,
    );
  }

  // Specific validator for IntlPhoneField
  String? Function(PhoneNumber?)? _getDefaultPhoneValidator() {
    if (widget.isOptional) return null;

    return (PhoneNumber? phoneNumber) {
      if (phoneNumber == null || phoneNumber.number.isEmpty) {
        return 'Phone number is required';
      }
      // We could add more validation logic here if needed
      return null;
    };
  }

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
      case TextFieldType.intlPhone:
        return TextInputType.phone;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.multiline:
      case TextFieldType.address:
        return TextInputType.multiline;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      case TextFieldType.date:
        return TextInputType.datetime;
      case TextFieldType.name:
      case TextFieldType.city:
      case TextFieldType.text:
      default:
        return TextInputType.text;
    }
  }

  int _getDefaultMaxLength() {
    switch (widget.fieldType) {
      case TextFieldType.name:
        return 30;
      case TextFieldType.email:
        return 50;
      case TextFieldType.password:
        return 30;
      case TextFieldType.phone:
      case TextFieldType.intlPhone:
        return 15;
      case TextFieldType.address:
        return 100;
      case TextFieldType.city:
        return 25;
      default:
        return 100;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[];

    switch (widget.fieldType) {
      case TextFieldType.name:
      case TextFieldType.city:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')));
        break;
      case TextFieldType.email:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')));
        break;
      case TextFieldType.phone:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9+() -]')));
        break;
      case TextFieldType.number:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9]')));
        break;
      case TextFieldType.password:
      // Allow a wide range of password characters
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]')));
        break;
      default:
      // No specific formatters for other types
        break;
    }

    if (widget.additionalFormatters != null) {
      formatters.addAll(widget.additionalFormatters!);
    }

    return formatters;
  }

  String? Function(String?)? _getDefaultValidator() {
    if (widget.isOptional) return null;

    switch (widget.fieldType) {
      case TextFieldType.email:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!_emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        };
      case TextFieldType.password:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        };
      case TextFieldType.phone:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Phone number is required';
          }
          if (!_phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
            return 'Please enter a valid phone number';
          }
          return null;
        };
      default:
        return (value) {
          if (value == null || value.isEmpty) {
            return '${widget.hintText} is required';
          }
          return null;
        };
    }
  }

  Widget? _getPasswordToggle() {
    if (widget.fieldType == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return null;
  }

  Widget? _getDefaultPrefixIcon() {
    switch (widget.fieldType) {
      case TextFieldType.email:
        return Icon(Icons.email, color: Colors.grey);
      case TextFieldType.password:
        return Icon(Icons.lock, color: Colors.grey);
      case TextFieldType.phone:
      case TextFieldType.intlPhone:
        return Icon(Icons.phone, color: Colors.grey);
      case TextFieldType.address:
        return Icon(Icons.location_on, color: Colors.grey);
      case TextFieldType.date:
        return Icon(Icons.calendar_today, color: Colors.grey);
      default:
        return null;
    }
  }
}

