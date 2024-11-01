import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_currency_info.freezed.dart';

part 'source_currency_info.g.dart';

@freezed
class SourceCurrencyInfo with _$SourceCurrencyInfo {
  const factory SourceCurrencyInfo({
    required String source,
    required Map<String, double> quotes,
  }) = _SourceCurrencyInfo;

  factory SourceCurrencyInfo.fromJson(Map<String, dynamic> json) =>
      _$SourceCurrencyInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'source': source,
        'quotes': quotes,
      };
}
