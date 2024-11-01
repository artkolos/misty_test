import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_test/domain/models/convert_info_symbols/convert_info_symbols.dart';

part 'convert_result.freezed.dart';

part 'convert_result.g.dart';

@freezed
class ConvertResult with _$ConvertResult {
  const factory ConvertResult({
    required ConvertInfoSymbols query,
    required double result,
  }) = _ConvertResult;

  factory ConvertResult.fromJson(Map<String, dynamic> json) =>
      _$ConvertResultFromJson(json);
}
