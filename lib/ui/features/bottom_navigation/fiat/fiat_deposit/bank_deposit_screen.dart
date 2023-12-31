import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'fiat_deposit_controller.dart';

class BankDepositScreen extends StatefulWidget {
  const BankDepositScreen({Key? key}) : super(key: key);

  @override
  State<BankDepositScreen> createState() => _BankDepositScreenState();
}

class _BankDepositScreenState extends State<BankDepositScreen> {
  final _controller = Get.find<FiatDepositController>();
  TextEditingController amountEditController = TextEditingController();
  TextEditingController coinEditController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  Timer? _timer;
  Rx<Wallet> selectedWallet = Wallet(id: 0).obs;
  Rx<FiatCurrency> selectedCurrency = FiatCurrency(id: 0).obs;
  RxInt selectedBankIndex = 0.obs;
  Rx<File> selectedFile = File("").obs;

  @override
  void initState() {
    selectedBankIndex.value = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSpacer10(),
        twoTextSpace("Enter amount".tr, "Select currency".tr),
        vSpacer5(),
        textFieldWithWidget(
          controller: amountEditController,
          type: TextInputType.number,
          hint: "Enter amount".tr,
          onTextChange: _onTextChanged,
          suffixWidget: Obx(() {
            return currencyView(context, selectedCurrency.value,
                _controller.fiatDepositData.value.currencyList ?? [],
                (selected) {
              selectedCurrency.value = selected;
              _getAndSetCoinRate();
            });
          }),
        ),
        vSpacer20(),
        twoTextSpace("Converted amount".tr, "Select wallet".tr),
        vSpacer5(),
        textFieldWithWidget(
          controller: coinEditController,
          readOnly: true,
          hint: "0",
          suffixWidget: Obx(
            () {
              return dropdownSuffix(
                  dropDownWallets(
                      _controller.fiatDepositData.value.walletList ?? [],
                      selectedWallet.value,
                      "Select".tr, onChange: (selected) {
                    selectedWallet.value = selected;
                    _getAndSetCoinRate();
                  }),
                  width: 150,
                  mainAxisAlignment: MainAxisAlignment.end);
            },
          ),
        ),
        vSpacer20(),
        twoTextSpace("Enter remark".tr, ""),
        vSpacer5(),
        textFieldWithWidget(
          controller: remarkController,
          type: TextInputType.multiline,
          maxLines: 4,
          hint: "Enter remark".tr,
        ),
        vSpacer20(),
        _documentView(),
        vSpacer20(),
        buttonRoundedMain(
          text: "Deposit".tr,
          onPressCallback: () => _checkInputData(),
        )
      ],
    );
  }

  Widget _bankDetailsView(int index) {
    final bank = _controller.fiatDepositData.value.banks?[index];
    return Column(
      children: [
        vSpacer5(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textAutoSizeKarla("Bank details".tr,
                fontSize: Dimens.regularFontSizeMid,
                color: context.theme.primaryColorLight),
            SizedBox(
                height: Dimens.iconSizeMid,
                child: buttonText("Copy",
                    bgColor: context.theme.primaryColorLight,
                    onPressCallback: () =>
                        copyToClipboard(bank?.toCopy() ?? ""))),
          ],
        ),
        vSpacer5(),
        Container(
          decoration: boxDecorationRoundBorder(),
          padding: const EdgeInsets.all(Dimens.paddingMid),
          child: Column(
            children: [
              twoTextSpaceFixed("Account Number".tr, bank?.iban ?? "",
                  maxLine: 2,
                  subMaxLine: 3,
                  color: context.theme.primaryColorLight,
                  fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Bank name".tr, bank?.bankName ?? "",
                  maxLine: 2,
                  subMaxLine: 3,
                  color: context.theme.primaryColorLight,
                  fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Bank address".tr, bank?.bankAddress ?? "",
                  maxLine: 2,
                  subMaxLine: 3,
                  color: context.theme.primaryColorLight,
                  fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed(
                  "Account holder name".tr, bank?.accountHolderName ?? "",
                  maxLine: 2,
                  subMaxLine: 3,
                  color: context.theme.primaryColorLight,
                  fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed(
                  "Account holder address".tr, bank?.accountHolderAddress ?? "",
                  maxLine: 2,
                  subMaxLine: 3,
                  color: context.theme.primaryColorLight,
                  fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Swift code".tr, bank?.swiftCode ?? "",
                  maxLine: 2,
                  subMaxLine: 3,
                  color: context.theme.primaryColorLight,
                  fontSize: Dimens.regularFontSizeExtraMid),
            ],
          ),
        )
      ],
    );
  }

  Widget _documentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: 150,
            child: buttonText("Select document".tr, onPressCallback: () {
              showImageChooser(context, (chooseFile, isGallery) {
                selectedFile.value = chooseFile;
              }, isCrop: false);
            })),
        Obx(() {
          final text = selectedFile.value.path.isEmpty
              ? "No document selected".tr
              : selectedFile.value.name;
          return Expanded(child: textAutoSizePoppins(text, maxLines: 2));
        })
      ],
    );
  }

  void _onTextChanged(String amount) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      _getAndSetCoinRate();
    });
  }

  void _getAndSetCoinRate() {
    if (selectedCurrency.value.id == 0 || selectedWallet.value.id == 0) return;
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      coinEditController.text = "0";
    } else {
      final bank = selectedBankIndex.value == -1
          ? null
          : _controller.fiatDepositData.value.banks?[selectedBankIndex.value];
      _controller.getCurrencyDepositRate(
          selectedWallet.value.id,
          amount,
          currency: selectedCurrency.value.code ?? "",
          bankId: bank?.id,
          (rate) => coinEditController.text = coinFormat(rate, fixed: 10));
    }
  }

  void _checkInputData() {
    if (selectedCurrency.value.id == 0) {
      showToast("select your currency".tr);
      return;
    }
    if (selectedWallet.value.id == 0) {
      showToast("select your wallet".tr);
      return;
    }
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Amount_less_then".trParams({"amount": "0"}));
      return;
    }
    // if (selectedBankIndex.value == -1) {
    //   showToast("select your bank".tr);
    //   return;
    // }
    debugPrint("Wall ID ==> ${selectedWallet.value.id}");
    if (selectedFile.value.path.isEmpty) {
      showToast("select bank document".tr);
      return;
    }

    // final bank =
    //     _controller.fiatDepositData.value.banks?[selectedBankIndex.value];
    _controller.currencyDepositProcess(
        selectedWallet.value.id,
        amount,
        currency: selectedCurrency.value.code ?? "",
        //bankId: bank?.id,
        file: selectedFile.value,
        () => _clearView());
  }

  void _clearView() {
    selectedCurrency.value = FiatCurrency(id: 0);
    selectedWallet.value = Wallet(id: 0);
    amountEditController.text = "";
    coinEditController.text = "";
    selectedBankIndex.value = -1;
    selectedFile.value = File("");
  }
}
