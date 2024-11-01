part of 'converter_cubit.dart';

@freezed
class ConverterState with _$ConverterState {
  const factory ConverterState.initial() = _Initial;

  const factory ConverterState.loading() = _Loading;

  const factory ConverterState.success({
    required List<Symbol> symbols,
    Symbol? fromSymbol,
    Symbol? toSymbol,
    double? result,
  }) = _Success;
}
