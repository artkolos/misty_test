import 'package:misty_test/domain/models/convert_result/convert_result.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';

abstract class SymbolsRepository {
  Future<List<Symbol>> getSymbols();

  Future<ConvertResult> convert({
    required String fromSymbol,
    required String toSymbol,
    required double amount,
  });
}
