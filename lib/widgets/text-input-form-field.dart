import 'package:flutter/material.dart';


class TextInputFormField extends StatelessWidget {
  String? title;
  double? maxWidth;
  FormFieldValidator<String>? validator;
  late final TextEditingController _controller;
  final bool obscureText;

  TextInputFormField({
    Key? key,
    this.title,
    this.maxWidth,
    this.obscureText = false,
    this.validator,
    TextEditingController? controller,
  }) : super(key: key) {
    _controller = controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    border ({Color color = const Color(0xff0068e6)}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
          width: 1,
          color: color
      ),
    );
    InputDecoration decoration() => InputDecoration(
      border: border(),
      disabledBorder: border(color: Colors.grey),
      errorBorder: border(color: Colors.red),
      enabledBorder: border(),
      focusedBorder: border(),
      focusedErrorBorder: border(color: Colors.red),
      filled: true,
      fillColor: Colors.white,
      // labelText: 'Enter your username',
    );

    return FormFieldWithTitle(
      title: title,
      maxInputWidth: maxWidth,
      optional: false,
      child: TextFormField(
        decoration: decoration(),
        obscureText: obscureText,
        validator: validator,
        controller: _controller,
      ),
    );
  }
}


class FormFieldWithTitle extends StatelessWidget {
  Widget child;
  double? maxInputWidth;
  String? title;
  bool optional;

  FormFieldWithTitle({this.title, required this.child, this.maxInputWidth, Key? key, this.optional=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.only(left: 2),
            child: Text(title! + (optional ? '' : ' *'), style: const TextStyle(
                color: Color(0xff0068e6),
                fontSize: 18
            )),
          ),
        const SizedBox(height: 11,),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxInputWidth ?? 310),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              child,
              if(!optional)
                ...[
                  const SizedBox(height: 4,),
                  const Text('* Required', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff0068e6)),)
                ]
            ],
          ),
        ),
      ],
    );
  }
}