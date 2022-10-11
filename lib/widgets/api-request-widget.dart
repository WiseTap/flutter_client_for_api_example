import 'package:flutter/material.dart';

const style = TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);

class JsonKey {
  final String keyName;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? hintText;

  JsonKey({required this.keyName, this.keyboardType = TextInputType.text, required this.controller, this.hintText});
}

class ApiRequestWidget extends StatefulWidget {
  final List<JsonKey>? jsonBodyRequest;
  final bool expanded;
  final Function (bool)? expandedChanged;
  final Function () sendRequest;
  final String method;
  final String path;
  final bool loading;

  ApiRequestWidget({Key? key, required this.method, required this.sendRequest, required this.path, this.expanded = false, this.jsonBodyRequest, this.expandedChanged, this.loading = false}) : super(key: key) {
    assert(expanded || expandedChanged != null);
  }

  @override
  State<ApiRequestWidget> createState() => _ApiRequestWidgetState();
}

class _ApiRequestWidgetState extends State<ApiRequestWidget> {

  Widget firstRow() {
    return Row(
      children: [
        RequestItemWidget(text: widget.method, margin: const EdgeInsets.only(right: 10)),
        RequestItemWidget(
          expanded: true,
          text: widget.path,
        ),
        if(widget.loading)
          Container(width: 40, height: 40, padding: const EdgeInsets.all(10), child: const CircularProgressIndicator(color: Color(0xff0068e6),),),
        if(!widget.loading)
          ...[
            if(widget.expanded)
              InkWell(
                child: Ink(
                  child: const RequestItemWidget(text: 'SEND', margin: EdgeInsets.only(left: 10),),
                ),
                onTap: () {
                  widget.sendRequest();
                },
              ),
            if(!widget.expanded)
              const RequestItemWidget(icon: Icons.expand_circle_down_rounded, margin: EdgeInsets.only(left: 10),),
          ]
      ],
    );
  }

  double get sw => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: const Color(0xff9ec3ff)),
          color: const Color(0xff9ec3ff)
      ),
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(widget.expanded)
            firstRow(),
          if(!widget.expanded)
            GestureDetector(
              onTap: () => widget.expandedChanged!(!widget.expanded),
              child: firstRow(),
            ),

          if(widget.expanded)
            ...[
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  border: Border.all(color: const Color(0xff619dff)),
                  color: const Color(0xff619dff),
                ),
                child: DataTable(
                  columnSpacing: 63,
                  columns: const [
                    DataColumn(label: Text('Header Key', style: style,)),
                    DataColumn(label: Text('Header Value', style: style,))
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('auth-token', style: style,)),
                        DataCell(Text('await FirebaseAuth.instance\n.currentUser.getIdToken()', style: style.copyWith(fontSize: 11, color: Colors.white70),))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              if(widget.jsonBodyRequest?.isNotEmpty == true)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    border: Border.all(color: const Color(0xff619dff)),
                    color: const Color(0xff619dff),
                  ),
                  child: DataTable(
                    columnSpacing: 10,
                    columns: const [
                      DataColumn(label: Text('JSON Key', style: style,)),
                      DataColumn(label: Text('JSON Value', style: style,))
                    ],
                    rows: widget.jsonBodyRequest!.map((e) {
                      return DataRow(
                        cells: [
                          DataCell(SizedBox(width: sw * 0.3, child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,child: Text(e.keyName, style: style,),),)),
                          DataCell(SizedBox(width: sw * 0.45, child: TextFormField(controller: e.controller, decoration: InputDecoration(hintText: e.hintText, hintStyle: TextStyle(color: Colors.white)), keyboardType: e.keyboardType, style: const TextStyle(color: Colors.white)),))
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ]
        ],
      ),
    );
  }
}



class RequestItemWidget extends StatelessWidget {
  final Color color;
  final EdgeInsets? margin;
  final String? text;
  final IconData? icon;
  final bool expanded;
  final String? title;

  const RequestItemWidget({this.margin, this.title, this.expanded = false, this.text, this.icon, this.color=const Color(0xff619dff), Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    child(CrossAxisAlignment crossAxisAlignment) => Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if(title?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Center(child: Text(title!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color:  Color(0xff0068e6)),),),
          ),
        Container(
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            border: Border.all(color: color),
            color: color,
          ),
          padding: const EdgeInsets.all(10),
          child: Builder(
            builder: (context) {
              if(text?.isNotEmpty == true) {
                return Text(text!, style: style.copyWith(fontSize: 14),);
              }
              if(icon != null) {
                return Icon(icon, color: Colors.white, size: 18,);
              }

              throw "text or icon should not be null";
            },
          ),
        )
      ],
    );
    if(expanded){
      return Expanded(
        child: child(CrossAxisAlignment.stretch),
      );
    }
    return child(CrossAxisAlignment.center);
  }
}