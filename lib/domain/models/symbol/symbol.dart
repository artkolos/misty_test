import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbol.freezed.dart';

part 'symbol.g.dart';

@freezed
class Symbol with _$Symbol {
  const factory Symbol({
    required String name,
  }) = _Symbol;

  factory Symbol.fromJson(Map<String, dynamic> json) => _$SymbolFromJson(json);

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
