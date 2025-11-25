import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

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
  final bool enabled;

  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

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
    this.onFilePicked,
    this.onDownload,
    this.enabled = true,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? uploadedFileName;
  String? _errorText;

  /// --- File Picker ---
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      setState(() {
        uploadedFileName = result.files.single.name;
      });
      widget.controller?.text = file.path;
      widget.onFilePicked?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget fieldChild;
    Widget? suffixIcon;

    // --- Handle different field types ---
    switch (widget.fieldType) {
      case FieldType.file:
        suffixIcon = _buildSuffixIcon(Icons.upload_file, _pickFile);
        break;
      case FieldType.download:
        suffixIcon = _buildSuffixIcon(Icons.download, widget.onDownload);
        break;
      // case FieldType.download:
      //   fieldChild = TextFormField(
      //     readOnly: true,
      //     decoration: const InputDecoration(border: InputBorder.none),
      //   );
      //   suffixIcon = _buildSuffixIcon(Icons.download, widget.onDownload);
      //   break;

      case FieldType.dob:
        suffixIcon = const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.calendar_today, size: 20, color: Colors.grey),
        );
        break;
      default:
        if (widget.isPassword) {
          suffixIcon = IconButton(
            icon: Icon(
              widget.obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: widget.togglePassword,
          );
        }
    }

    // --- Build decoration ---
    InputDecoration decoration = _buildDecoration(suffix: suffixIcon).copyWith(
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      // helperText: "",
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      fillColor: widget.enabled ? Colors.white : Colors.grey.shade200,
    );

    // --- Field Rendering ---
    switch (widget.fieldType) {
      case FieldType.dropdown:
        fieldChild = DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          initialValue:
              (widget.selectedValue == null || widget.selectedValue!.isEmpty)
              ? "Select"
              : widget.selectedValue,
          decoration: decoration.copyWith(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: [
            const DropdownMenuItem(
              value: "Select",
              child: Text("Select", style: TextStyle(color: Colors.grey)),
            ),
            ...?widget.dropdownItems?.map(
              (item) => DropdownMenuItem(value: item, child: Text(item)),
            ),
          ],
          onChanged: widget.enabled
              ? (val) {
                  if (val == "Select") {
                    widget.onChanged?.call(null);
                  } else {
                    widget.onChanged?.call(val);
                  }
                }
              : null,
        );
        break;

      case FieldType.file:
        fieldChild = TextFormField(
          readOnly: true,
          onTap: widget.enabled ? _pickFile : null,
          controller: TextEditingController(text: uploadedFileName ?? ''),
          decoration: decoration.copyWith(
            hintText: uploadedFileName ?? widget.hint ?? 'Upload File',
          ),
        );
        break;

      default:
        fieldChild = TextFormField(
          enabled: true,
          readOnly: !widget.enabled,
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText,
          style: TextStyle(color: Colors.black.withOpacity(0.9)),
          maxLines: widget.fieldType == FieldType.note ? null : 1,
          minLines: widget.fieldType == FieldType.note ? 1 : 1,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          decoration: decoration.copyWith(
            counterText: "",
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.grey),
          ),

          validator: (val) {
            final error = widget.validator?.call(val);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _errorText = error);
            });
            return error;
          },
        );
    }

    final bool hasError = _errorText != null && _errorText!.isNotEmpty;

    // --- Final Layout ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2596BE), Color(0xFF64C7A6)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: BoxDecoration(
                color: widget.enabled ? Colors.white : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.fieldType == FieldType.download
                  ? GestureDetector(
                      onTap: widget.onDownload,
                      child: AbsorbPointer(child: fieldChild),
                    )
                  : fieldChild,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Text(
              _errorText ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }

  /// --- Helper to build suffix icons ---
  Padding _buildSuffixIcon(IconData icon, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, size: 20, color: Colors.grey),
      ),
    );
  }

  /// --- Decoration builder with label handling ---
  // InputDecoration _buildDecoration({Widget? suffix}) {
  //   final hasStar = widget.label.contains('*');
  //   final parts = widget.label.split('*');

  //   return InputDecoration(
  //     label: hasStar
  //         ? RichText(
  //             text: TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: parts[0].trim(),
  //                   style: const TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 20.0,
  //                     backgroundColor: Colors.white,
  //                   ),
  //                 ),
  //                 const TextSpan(
  //                   text: ' *',
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 20.0,
  //                     backgroundColor: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         : Text(
  //             widget.label,
  //             style: const TextStyle(
  //               color: Colors.black,
  //               fontSize: 20.0,
  //               backgroundColor: Colors.white,
  //             ),
  //           ),
  //     filled: true,
  //     fillColor: Colors.white,
  //     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: BorderSide.none,
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: BorderSide.none,
  //     ),
  //     floatingLabelBehavior: FloatingLabelBehavior.always,
  //     hintStyle: const TextStyle(color: Colors.grey),
  //     suffixIcon: suffix,
  //     suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
  //   );
  // }

  InputDecoration _buildDecoration({Widget? suffix}) {
    final hasStar = widget.label.contains('*');
    final parts = widget.label.split('*');

    return InputDecoration(
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        margin: const EdgeInsets.only(left: 8, bottom: 4),
        color: Colors.white,
        child: hasStar
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: parts[0].trim(),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              )
            : Text(
                widget.label,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
      ),

      floatingLabelBehavior: FloatingLabelBehavior.always,

      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),

      suffixIcon: suffix,
    );
  }
}
