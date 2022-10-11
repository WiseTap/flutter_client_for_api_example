import 'package:flutter/material.dart';

import 'api-request-widget.dart';

class ApiResponseWidget extends StatefulWidget {
  final String method;
  final String path;
  final bool success;
  Map<String, dynamic> payload;

  ApiResponseWidget({Key? key, required this.success, required this.method, required this.path, required this.payload}) : super(key: key);

  @override
  State<ApiResponseWidget> createState() => _ApiResponseWidgetState();
}

class _ApiResponseWidgetState extends State<ApiResponseWidget> {

  Color get color => widget.success ? const Color(0xff03872d) : const Color(0xffbf5063);
  Color get backgroundColor => widget.success ? const Color(0xff16c93d) : const Color(0xffffabb9);

  Widget firstRow({required String method, required String path, required bool expanded, Color color = const Color(0xff0068e6)}) {
    return Row(
      children: [
        RequestItemWidget(text: method, margin: EdgeInsets.only(right: 10), color: color),
        RequestItemWidget(
          expanded: true,
          text: path,
          color: color,
        ),
        RequestItemWidget(text: widget.success ? 'SUCCESS' : 'FAILED', margin: EdgeInsets.only(left: 10), color: color),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: backgroundColor),
          color: backgroundColor
      ),
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          firstRow(expanded: false, method: widget.method, path: widget.path, color: color),
          const SizedBox(height: 3,),
          DataTable(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: backgroundColor),
                color: color
            ),
            columnSpacing: 63,
            columns: const [
              DataColumn(label: Text('JSON Key', style: style,)),
              DataColumn(label: Text('JSON Value', style: style,))
            ],
            rows: widget.payload.keys.map((key) {
              return DataRow(
                 cells: [
                    DataCell(Text(key, style: style,)),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(width: 170),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(widget.payload[key].toString(), style: style),
                        ),
                      )
                    )
                 ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

