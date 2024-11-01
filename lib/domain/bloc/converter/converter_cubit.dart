import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';
import 'package:misty_test/domain/repository/symbols_repository.dart';

part 'converter_cubit.freezed.dart';

part 'converter_state.dart';

@injectable
class ConverterCubit extends Cubit<ConverterState> {
  ConverterCubit(this.symbolsRepository)
      : super(
          const ConverterState.initial(),
        );

  final SymbolsRepository symbolsRepository;

  final List<Symbol> _symbols = List.empty(growable: true);

  Symbol? _fromSymbol;
  Symbol? _toSymbol;
  String _amount = '';

  Future<void> getSymbols() async {
    final list = await symbolsRepository.getSymbols();
    _symbols.addAll(list);
    emit(ConverterState.success(symbols: _symbols));
  }

  void selectFromSymbol(Symbol? symbol) {
    _fromSymbol = symbol;
    emit(
      ConverterState.success(
          symbols: _symbols, fromSymbol: _fromSymbol, toSymbol: _toSymbol),
    );
    _convert(_amount);
  }

  void selectToSymbol(Symbol? symbol) {
    _toSymbol = symbol;
    emit(
      ConverterState.success(
          symbols: _symbols, fromSymbol: _fromSymbol, toSymbol: _toSymbol),
    );
    _convert(_amount);
  }

  void enterAmount(String amount) {
    if (amount.isEmpty) {
      emit(
        ConverterState.success(
          symbols: _symbols,
          fromSymbol: _fromSymbol,
          toSymbol: _toSymbol,
          result: null,
        ),
      );
      return;
    }
    if (amount.contains(',')) {
      _amount = amount.replaceFirst(',', '.');
    } else {
      _amount = amount;
    }
    _convert(_amount);
  }

  Future<void> _convert(String amount) async {
    if (amount.isNotEmpty && _fromSymbol != null && _toSymbol != null) {
      final result = await symbolsRepository.convert(
        fromSymbol: _fromSymbol!.name,
        toSymbol: _toSymbol!.name,
        amount: double.tryParse(amount) ?? 0,
      );
      emit(
        ConverterState.success(
          symbols: _symbols,
          fromSymbol: _fromSymbol,
          toSymbol: _toSymbol,
          result: result.result,
        ),
      );
    }
  }
}
