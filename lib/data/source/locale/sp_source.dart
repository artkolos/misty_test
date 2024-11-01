import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';
import 'package:shared_preferences/shared_preferences.dart';

@preResolve
@singleton
class SpSource {
  static const String _symbols = 'symbols';

  final SharedPreferences _sharedPreferences;

  SpSource._(this._sharedPreferences);

  @factoryMethod
  static Future<SpSource> create() async {
    final sharedPreference = await SharedPreferences.getInstance();
    return SpSource._(sharedPreference);
  }

  List<Symbol>? getSymbols() {
    final listStr = _sharedPreferences.getStringList(_symbols);
    final listMap = listStr?.map((e) => jsonDecode(e)).toList();
    return listMap?.map((e) => Symbol.fromJson(e)).toList();
  }

  void setSymbols(List<Symbol> symbols) {
    final listMaps = symbols.map((e) => e.toJson()).toList();
    final listStr = listMaps.map((e) => jsonEncode(e)).toList();
    _sharedPreferences.setStringList(_symbols, listStr);
  }
}
