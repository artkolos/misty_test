import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:misty_test/data/source/locale/sp_source.dart';
import 'package:misty_test/data/source/remote/rest_source.dart';
import 'package:misty_test/domain/models/convert_result/convert_result.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';
import 'package:misty_test/domain/repository/symbols_repository.dart';

@LazySingleton(as: SymbolsRepository)
class SymbolsRepositoryImpl extends SymbolsRepository {
  final RestSource restSource;
  final SpSource spSource;

  SymbolsRepositoryImpl(this.restSource,
      this.spSource,);

  @override
  Future<List<Symbol>> getSymbols() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    if (hasInternet) {
      final symbols = await restSource.getSymbols();
      spSource.setSymbols(symbols);
      return symbols;
    } else {
      return spSource.getSymbols() ?? [];
    }
  }

  @override
  Future<ConvertResult> convert({
    required String fromSymbol,
    required String toSymbol,
    required double amount,
  }) =>
      restSource.convert(
        fromSymbol: fromSymbol,
        toSymbol: toSymbol,
        amount: amount,
      );
}
