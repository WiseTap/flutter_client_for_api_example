import 'package:flutter_client_for_api_example/data/api.dart';
import 'package:flutter_client_for_api_example/data/responses/http-error.dart';
import 'package:flutter_client_for_api_example/widgets/api-response-widget.dart';
import 'package:flutter_client_for_api_example/widgets/example-app-bar.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import '../widgets/api-request-widget.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _ResponseMapBody {
  final bool success;
  final String method;
  final String path;
  final Map<String,dynamic> payload;
  
  _ResponseMapBody({required this.success, required this.method, required this.path, this.payload = const {}});
}

class _DashboardPageState extends State<DashboardPage> {
  int expanded = -1;
  int loadingItem = -1;
  final responses = <_ResponseMapBody>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ExampleAppBar(title: 'Dashboard', icon: Icons.dashboard),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              _CreateProductApiRequestWidget(
                item: 0,
                page: this,
                loading: loadingItem == 0,
                expanded: expanded == 0,
                expandedChanged: (expanded) {
                  setState(() {
                    if(expanded) {
                      this.expanded = 0;
                    } else {
                      this.expanded = -1;
                    }
                  });
                },
              ),

              const SizedBox(height: 10,),

              ApiRequestWidget(
                method: 'GET',
                path: '/all-products-resumed',
                loading: loadingItem == 1,
                sendRequest: () => requestHandler(item: 1, method: 'GET', path: '/product', request: () => Api().getProducts()),
                expanded: expanded == 1,
                expandedChanged: (expanded) {
                  setState(() {
                    if(expanded) {
                      this.expanded = 1;
                    } else {
                      this.expanded = -1;
                    }
                  });
                },
              ),

              const SizedBox(height: 10,),

              _GetProductByIdApiRequestWidget(
                item: 2,
                loading: loadingItem == 2,
                page: this,
                expanded: expanded == 2,
                fullDetails: false,
                expandedChanged: (expanded) {
                  setState(() {
                    if(expanded) {
                      this.expanded = 2;
                    } else {
                      this.expanded = -1;
                    }
                  });
                },
              ),

              const SizedBox(height: 10,),

              _GetProductByIdApiRequestWidget(
                item: 3,
                loading: loadingItem == 3,
                page: this,
                expanded: expanded == 3,
                fullDetails: true,
                expandedChanged: (expanded) {
                  setState(() {
                    if(expanded) {
                      this.expanded = 3;
                    } else {
                      this.expanded = -1;
                    }
                  });
                },
              ),
              
              ...responses.map((response) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ApiResponseWidget(
                    success: response.success,
                    method: response.method,
                    path: response.path,
                    payload: response.payload,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void requestHandler({required int item, required String method, required String path, required Future<dartz.Either<HttpError, dynamic>> Function () request}) {
    setState(() {
      expanded = -1;
      loadingItem = item;

      request().then((result){
        setState(() {
          loadingItem = -1;
          
          result.fold((l) {
            responses.insert(0, _ResponseMapBody(success: false, method: method, path: path, payload: {'code': l.code, 'description': l.description, 'status': l.status}));
          }, (r) {
            final map = Map<String,dynamic>.from(r ?? {});
            responses.insert(0, _ResponseMapBody(success: true, path: path, method: method, payload: map));
          });
        });
      });
    });
  }
}

class _CreateProductApiRequestWidget extends StatefulWidget {
  final bool expanded;
  final Function (bool)? expandedChanged;
  final int item;
  _DashboardPageState page;
  bool loading;

  _CreateProductApiRequestWidget({Key? key, required this.loading, required this.page, required this.item, this.expanded = false, this.expandedChanged}) : super(key: key);

  @override
  State<_CreateProductApiRequestWidget> createState() => _CreateProductApiRequestWidgetState();
}

class _CreateProductApiRequestWidgetState extends State<_CreateProductApiRequestWidget> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final internalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ApiRequestWidget(
      method: 'POST',
      path: '/product',
      expanded: widget.expanded,
      expandedChanged: widget.expandedChanged,
      loading: widget.loading,
      sendRequest: () {
        widget.page.requestHandler(
            item: widget.item,
            method: 'POST',
            path: '/product',
            request: () => Api().createProduct(
              name: nameController.text,
              stockQuantity: int.parse(stockQuantityController.text),
              internalCode: internalCodeController.text,
              price: double.parse(priceController.text)
            ),
        );
      },
      jsonBodyRequest: [
        JsonKey(keyName: 'Name', controller: nameController, hintText: 'string'),
        JsonKey(keyName: 'Price (USD)', keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false), controller: priceController, hintText: 'number'),
        JsonKey(keyName: 'Stock Quantity', keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false), controller: stockQuantityController, hintText: 'number'),
        JsonKey(keyName: 'Internal Code', controller: internalCodeController, hintText: 'string'),
      ],
    );
  }

}

class _GetProductByIdApiRequestWidget extends StatefulWidget {
  
  _GetProductByIdApiRequestWidget({Key? key, required this.item, required this.fullDetails, required this.page, required this.expanded, required this.expandedChanged, required this.loading}) : super(key: key);

  bool fullDetails;
  _DashboardPageState page;
  bool loading;
  final bool expanded;
  final int item;
  final Function (bool)? expandedChanged;

  @override
  State<_GetProductByIdApiRequestWidget> createState() => _GetProductByIdApiRequestWidgetState();
}

class _GetProductByIdApiRequestWidgetState extends State<_GetProductByIdApiRequestWidget> {
  final productIdController = TextEditingController();

  String get path => widget.fullDetails 
      ? '/product/:productId/full-details'
      : '/product/:productId';
  
  @override
  Widget build(BuildContext context) {
    return ApiRequestWidget(
      method: 'GET',
      path: path,
      loading: widget.loading,
      sendRequest: () => widget.page.requestHandler(item: widget.item, method: 'GET', path: path, request: () {
        if(widget.fullDetails){
          return Api().getProductByIdWithFullDetails(productId: productIdController.text);
        } else {
          return Api().getProductById(productId: productIdController.text);
        }
      }),
      expanded: widget.expanded,
      expandedChanged: widget.expandedChanged,
      jsonBodyRequest: [
        JsonKey(controller: productIdController, keyName: ':productId', hintText: 'string'),
      ],
    );
  }

}
