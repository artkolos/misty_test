import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:misty_test/core/extensions/locale_ext.dart';
import 'package:misty_test/core/extensions/theme_ext.dart';
import 'package:misty_test/domain/bloc/converter/converter_cubit.dart';
import 'package:misty_test/injection.dart';
import 'package:misty_test/presentation/main_flow/widgets/app_text_field.dart';
import 'package:misty_test/presentation/main_flow/widgets/app_drop_down_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String _debounceOnChange = 'onChangeText';

  final TextEditingController _youSendController = TextEditingController();
  final TextEditingController _theyGetController = TextEditingController();

  final _converterCubit = getIt.get<ConverterCubit>();

  @override
  void dispose() {
    _youSendController.dispose();
    _theyGetController.dispose();
    _converterCubit.close();
    EasyDebounce.cancel(_debounceOnChange);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _converterCubit.getSymbols();
    _youSendController.addListener(
      () {
        EasyDebounce.debounce(
          _debounceOnChange,
          const Duration(milliseconds: 500),
          () {
            if (_youSendController.text.isEmpty) {
              _theyGetController.text = '';
              return;
            }
            _converterCubit.enterAmount(_youSendController.text.trim());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _converterCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.primary,
          title: Text(
            context.locale.currencyConverter,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
        ),
        body: BlocConsumer<ConverterCubit, ConverterState>(
          listener: (context, state) {
            state.mapOrNull(
              success: (success) {
                if (success.result != null) {
                  _theyGetController.text = success.result.toString();
                }
              },
            );
          },
          bloc: _converterCubit,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.youSend,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AppTextField(controller: _youSendController),
                      ),
                      const Gap(14),
                      state.map(
                        initial: (initial) => const SizedBox(),
                        loading: (loading) => const SizedBox(),
                        success: (success) => AppDropDownButton(
                          converterCubit: _converterCubit,
                          symbols: success.symbols,
                          currentSymbol: success.fromSymbol,
                          title: success.fromSymbol?.name,
                        ),
                      ),
                    ],
                  ),
                  const Gap(14),
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/compare_arrow.svg',
                      colorFilter: ColorFilter.mode(
                        context.theme.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 35,
                    ),
                  ),
                  const Gap(14),
                  Text(
                    context.locale.theyGet,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _theyGetController,
                          ignorePointers: true,
                        ),
                      ),
                      const Gap(14),
                      state.map(
                        initial: (initial) => const SizedBox(),
                        loading: (loading) => const SizedBox(),
                        success: (success) => AppDropDownButton(
                          converterCubit: _converterCubit,
                          symbols: success.symbols,
                          isFromSymbol: false,
                          currentSymbol: success.toSymbol,
                          title: success.toSymbol?.name,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
