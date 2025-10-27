import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum FieldType { text, password, dropdown, file, note, dob, download }

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final bool obscureText;
  final TextEditingController? controller;
  final bool isPassword;
  final VoidCallback? togglePassword;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  final FieldType fieldType;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<File>? onFilePicked;
  final VoidCallback? onDownload;

  // SVG icon
  final String? customIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.controller,
    this.isPassword = false,
    this.togglePassword,
    this.focusNode,
    this.validator,
    this.fieldType = FieldType.text,
    this.dropdownItems,
    this.selectedValue,
    this.onChanged,
    this.customIcon,
    this.onFilePicked,
    this.onDownload,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? uploadedFileName;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);

      setState(() {
        uploadedFileName = result.files.single.name;
      });

      widget.controller?.text = file.path;

      // Trigger the callback
      if (widget.onFilePicked != null) {
        widget.onFilePicked!(file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget fieldChild;

    // Determine suffix icon based on field type
    Widget? suffixIcon;
    switch (widget.fieldType) {
      case FieldType.file:
        suffixIcon = Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: _pickFile,
            child: SvgPicture.asset(
              widget.customIcon ?? 'assets/icon/upload.svg',
            ),
          ),
        );
        break;

      case FieldType.download:
        suffixIcon = Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: widget.onDownload,
            child: SvgPicture.asset(
              widget.customIcon ?? 'assets/icon/arrow-up.svg',
            ),
          ),
        );
        break;

      case FieldType.dropdown:
        suffixIcon = Padding(
          padding: const EdgeInsets.only(right: 0),
          child: SvgPicture.asset(
            widget.customIcon ?? 'assets/icon/arrow-down.svg',
          ),
        );
        break;

      case FieldType.dob:
        suffixIcon = Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SvgPicture.asset(
            widget.customIcon ?? 'assets/icon/calendar.svg',
          ),
        );
        break;

      default:
        if (widget.isPassword) {
          suffixIcon = IconButton(
            icon: Icon(
              widget.obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: widget.togglePassword,
          );
        }
    }

    // Determine field child based on field type
    switch (widget.fieldType) {
      case FieldType.dropdown:
        fieldChild = DropdownButtonFormField<String>(
          initialValue: widget.selectedValue,
          items: widget.dropdownItems
              ?.map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          decoration: _inputDecoration(suffix: suffixIcon),
        );
        break;

      case FieldType.file:
        fieldChild = TextFormField(
          readOnly: true,
          onTap: _pickFile,
          controller: TextEditingController(text: uploadedFileName ?? ''),
          decoration: _inputDecoration(suffix: suffixIcon).copyWith(
            hintText: uploadedFileName ?? widget.hint ?? "Upload File",
          ),
        );
        break;

      case FieldType.download:
        fieldChild = TextFormField(
          readOnly: true,
          controller: widget.controller,
          decoration: _inputDecoration(
            suffix: suffixIcon,
          ).copyWith(hintText: widget.hint ?? "Download File"),
        );
        break;

      case FieldType.note:
        fieldChild = TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator,
          maxLines: 5,
          decoration: _inputDecoration(suffix: suffixIcon),
        );
        break;

      default:
        fieldChild = TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText,
          validator: widget.validator,
          style: const TextStyle(color: Colors.black),
          decoration: _inputDecoration(suffix: suffixIcon),
        );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2596BE), Color(0xFF64C7A6)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(1.5), child: fieldChild),
    );
  }

  InputDecoration _inputDecoration({Widget? suffix}) {
    // Check if label contains '*'
    final hasStar = widget.label.contains('*');
    final parts = widget.label.split('*');

    return InputDecoration(
      label: hasStar
          ? RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: parts[0].trim(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              widget.label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                backgroundColor: Colors.white,
              ),
            ),
      hintText: widget.hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.transparent, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.transparent, width: 2),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    );
  }
}
