import 'dart:async';
import 'dart:developer';
import 'package:flutter_client_for_api_example/data/requests/create-account-req.dart';
import 'package:flutter_client_for_api_example/data/custom-claims.dart';
import 'package:flutter_client_for_api_example/data/requests/create-product-req.dart';
import 'package:flutter_client_for_api_example/data/responses/create-account-response-body.dart';
import 'package:flutter_client_for_api_example/data/responses/http-error.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.0.31:3000')); //TODO: replace with your ipv4 address
  String? _uid;
  String? _idToken;
  
  Api._() {
    FirebaseAuth.instance.idTokenChanges().listen((user) {
      log('idToken changed, user is ${user != null ? 'not null': 'null'}');

      if(user == null) {
        _uid = _idToken = null;
      } else {
        user.getIdToken().then((idToken){
          log('idToken refreshed');
          _idToken = idToken;
          _uid = user.uid;
        });
      }
    });

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['auth-token'] = _idToken;
        handler.next(options);
      }
    ));
  }

  static Api? _api;
  factory Api () {
    if(_api == null) {
      _api = Api._();
    }
    return _api!;
  }

  /// Creates the user account
  Future<Either<HttpError, CreateAccountResBody>> createAccount ({required String name, required String email, required String password, required CustomClaims role}) async {
    try {
      final result = await _dio.post('/account', data: CreateAccountReqBody(name: name, email: email, password: password, role: role).toMap(),);
      return right(CreateAccountResBody.fromMap(result.data));
    }catch(e){
      return left(_httpCodeError(e));
    }
  }

  Future<Either<HttpError, dynamic>> getProducts() async {
    try {
      final result = await _dio.get('/all-products-resumed',);
      return right(Map.from(result.data ?? {}));
    } catch(e){
      return left(_httpCodeError(e));
    }
  }
  Future<Either<HttpError, dynamic>> getProductByIdWithFullDetails({required String productId}) async {
    try {
      final result = await _dio.get('/product/$productId/full-details',);
      return right(Map.from(result.data ?? {}));
    } catch(e){
      return left(_httpCodeError(e));
    }
  }

  Future<Either<HttpError, dynamic>> getProductById({required String productId}) async {
    try {
      final result = await _dio.get('/product/$productId',);
      return right(Map.from(result.data ?? {}));
    } catch(e){
      return left(_httpCodeError(e));
    }
  }


  Future<Either<HttpError, dynamic>> createProduct ({required String name, required double price, required String internalCode, required int stockQuantity}) async {
    try {
      final result = await _dio.post('/product', data: CreateProductReqBody(name: name, price: price, internalCode: internalCode, stockQuantity: stockQuantity).toMap(),);
      return right(result.data);
    }catch(e){
      return left(_httpCodeError(e));
    }
  }

  HttpError _httpCodeError(error) {
    final errorString = error.toString();

    if(errorString.contains('SocketException')){
      return HttpError(code: 'TIMEOUT', status: 408, description: 'Please check your connection');
    }
    return HttpError.fromDioError(error);
  }

}