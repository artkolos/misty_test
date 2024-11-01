import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:misty_test/domain/models/convert_result/convert_result.dart';
import 'package:misty_test/domain/models/source_currency_info/source_currency_info.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';

@singleton
class RestSource {
  static const String _baseUrl = 'https://api.currencylayer.com';
  static const String _symbols = '/list';
  static const String _convert = '/convert';
  static const String _live = '/live';
  static const String _accessKey = '3d7d8adf6cb2038360bfd436965a8e7a';
  static const String _accessKeyParam = 'access_key';
  static const String _fromSymbolParam = 'from';
  static const String _toSymbolParam = 'to';
  static const String _sourceParam = 'source';
  static const String _amountParam = 'amount';

  final Dio _dio;

  RestSource._(this._dio);

  @factoryMethod
  static RestSource create() {
    final dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
        connectTimeout: const Duration(seconds: 40),
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return RestSource._(dio);
  }

  Future<List<Symbol>> getSymbols() async {
    final response = await _dio.get(
      _symbols,
      queryParameters: {
        _accessKeyParam: _accessKey,
      },
    );
    final List<Symbol> symbols =
        (response.data['currencies'] as Map<String, dynamic>)
            .keys
            .map(
              (e) => Symbol(name: e),
            )
            .toList();
    return symbols;
  }

  Future<SourceCurrencyInfo> sourceCurrency(String currency) async {
    final response = await _dio.get(
      _live,
      queryParameters: {
        _accessKeyParam: _accessKey,
        _sourceParam: currency,
      },
    );
    return SourceCurrencyInfo.fromJson(response.data);
  }

  Future<ConvertResult> convert({
    required String fromSymbol,
    required String toSymbol,
    required double amount,
  }) async {
    final response = await _dio.get(
      _convert,
      queryParameters: {
        _accessKeyParam: _accessKey,
        _amountParam: amount,
        _toSymbolParam: toSymbol,
        _fromSymbolParam: fromSymbol,
      },
    );
    Logger().i(response.data);
    return ConvertResult.fromJson(response.data);
  }
}
