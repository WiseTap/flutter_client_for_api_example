import 'package:flutter/material.dart';



class Divider2 extends StatelessWidget {
  Color color;

  Divider2({this.color:Colors.black, Key? key}) : super(key: key);

  _item (List<Color> colors) => Row(
    children: [
      Expanded(
        child: Container(
          height: 1,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // stops: const [.01,.5,.9],
                  stops: [/*.00005,*/.6,.9],
                  colors: colors
              )
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                // color: color.withOpacity(0.47),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0,2)
            )
          ],
          border: const Border(
              top: BorderSide.none,
              left  : BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                color: Colors.white,
                style: BorderStyle.solid,
                width: 1,
              )
          )
      ),
    );
    // return Column(
    //   children: [
    //     _item([
    //       const Color(0xffc1c1c1),
    //       Colors.white,
    //     ]),
    //     _item([
    //       const Color(0xffd1d1d1),
    //       Colors.white,
    //     ]),
    //     _item([
    //       const Color(0xffe0e0e0),
    //       Colors.white,
    //     ]),
    //     _item([
    //       const Color(0xffefefef),
    //       Colors.white,
    //     ]),
    //   ],
    // );
  }
}

class Divider3 extends StatelessWidget {
  EdgeInsets? margin;
  final Color? color;

  Divider3({Key? key, this.margin, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Container(height: 1, width: double.infinity, color: color ?? Colors.grey.withOpacity(0.1),),
      ),
    );
  }
}
