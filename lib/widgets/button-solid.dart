
import 'package:flutter/material.dart';
import '../main.dart';



class ButtonSolid extends StatefulWidget {
  final String text;
  VoidCallback? onTap;
  bool errorStyle;
  double? width;
  Color bgColor;

  ButtonSolid({Key? key, required this.text, this.onTap, this.bgColor = const Color(0xff0068e6), this.width, this.errorStyle=false}) : super(key: key);

  @override
  State<ButtonSolid> createState() => _ButtonSolidState();
}

class _ButtonSolidState extends State<ButtonSolid> {
  bool hovering = false;
  bool tapped = false;
  bool disposed = false;
  bool get enabled => widget.onTap != null;

  Color get color {
    if(widget.errorStyle){
      return Colors.red;
    }
    return tapped
        ? widget.bgColor
        : (enabled ? widget.bgColor : widget.bgColor.withOpacity(0.5));
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      enabled: enabled,
      onShowHoverHighlight: (hovering) {  setState((){ this.hovering = hovering; });},

      child: InkWell(
        onTap: widget.onTap == null ? null : () {
          widget.onTap!();
          setState((){
            tapped = true;
          });
          Future.delayed(const Duration(milliseconds: 380,), () {
            if(!disposed) {
              setState(() {
                tapped = false;
              });
            }
          });
        },
        child: Ink(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: widget.width,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100000),
                boxShadow: [
                  if(hovering && enabled && !tapped)
                    BoxShadow(
                      color: widget.bgColor.withOpacity(0.6),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0,0),
                    ),
                  // if(tapped)
                  //   const BoxShadow(
                  //     color: color6,
                  //     spreadRadius: 1,
                  //     blurRadius: 10,
                  //     offset: Offset(0,0),
                  //   ),
                ]
            ),
            child: Center(
              child: Text(widget.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, letterSpacing: 0.7, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
