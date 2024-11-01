import 'package:flutter/material.dart';
import 'package:misty_test/core/extensions/locale_ext.dart';
import 'package:misty_test/core/extensions/theme_ext.dart';
import 'package:misty_test/domain/bloc/converter/converter_cubit.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';
import 'package:misty_test/presentation/main_flow/widgets/app_drop_down_item.dart';

class AppDropDownButton extends StatefulWidget {
  const AppDropDownButton({
    super.key,
    required this.symbols,
    this.isFromSymbol = true,
    this.title,
    required this.converterCubit,
    this.currentSymbol,
  });

  final List<Symbol> symbols;
  final String? title;
  final ConverterCubit converterCubit;
  final Symbol? currentSymbol;
  final bool isFromSymbol;

  @override
  State<AppDropDownButton> createState() => _AppDropDownButtonState();
}

class _AppDropDownButtonState extends State<AppDropDownButton> {
  final ValueNotifier<Symbol?> _currentSymbolNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _currentSymbolNotifier.value = widget.currentSymbol;
  }

  @override
  void dispose() {
    _currentSymbolNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
          ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  // title: Text(context.locale.chooseCurrency),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.locale.chooseCurrency,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: _currentSymbolNotifier,
                            builder: (context, symbol, _) {
                              return Expanded(
                                child: ListView(
                                  children: [
                                    ...widget.symbols.map(
                                      (e) => AppDropDownItem(
                                        currentSymbol: symbol,
                                        value: e,
                                        title: e.name,
                                        onTap: (value) {
                                          _currentSymbolNotifier.value = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                context.locale.cansel,
                                style: TextStyle(
                                  color: context.theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: _currentSymbolNotifier,
                                builder: (context, symbol, _) {
                                  return TextButton(
                                    onPressed: () {
                                      if (widget.isFromSymbol) {
                                        widget.converterCubit
                                            .selectFromSymbol(symbol);
                                      } else {
                                        widget.converterCubit
                                            .selectToSymbol(symbol);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      context.locale.ok,
                                      style: TextStyle(
                                        color:
                                            context.theme.colorScheme.primary,
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(
            Icons.arrow_drop_down_sharp,
            color: context.theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
