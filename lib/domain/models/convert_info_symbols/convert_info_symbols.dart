import 'package:freezed_annotation/freezed_annotation.dart';

part 'convert_info_symbols.freezed.dart';

part 'convert_info_symbols.g.dart';

@freezed
class ConvertInfoSymbols with _$ConvertInfoSymbols {
  const factory ConvertInfoSymbols({
    required String from,
    required String to,
    required double amount,
  }) = _ConvertInfoSymbols;

  factory ConvertInfoSymbols.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ConvertInfoSymbolsFromJson(json);
}
