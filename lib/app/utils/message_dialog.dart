import 'package:flutter/material.dart';
import 'package:flutter_app_test/app/theme/theme.dart';
import 'package:get/get.dart';

class MessageDialog {
  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static void confirm(
    String message, {
    required String title,
    String? confirmButtonText,
    Color? confirmButtonColor,
    String? cancelButtonText,
    Color? cancelButtonColor = Colors.black12,
    TextStyle? errorTextStyle,
    Function? onClosed,
    Function? onConfirmed,
  }) {
    _showDialog(
      content: message,
      title: title,
      contentTextStyle: errorTextStyle ??
          const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      onClosed: onClosed,
      onConfirmed: onConfirmed,
      confirmButtonText: confirmButtonText,
      confirmButtonColor: confirmButtonColor,
      cancelButtonText: cancelButtonText,
      cancelButtonColor: cancelButtonColor,
      isConfirmDialog: true,
    );
  }

  static void showMessage(
    String message, {
    required String title,
    TextStyle? contentTextStyle,
    Function? onClosed,
    Color textColor = Colors.black,
  }) {
    _showDialog(
      content: message,
      title: title,
      contentTextStyle: contentTextStyle ??
          TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
      onClosed: onClosed,
    );
  }

  static void showError({String? message, String? title, TextStyle? contentTextStyle, Function? onClosed}) {
    _showDialog(
      content: message ?? 'An error has occurred. Please try again.',
      title: 'Error',
      contentTextStyle: contentTextStyle ??
          const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      onClosed: onClosed,
    );
  }

  static void _showDialog({
    required String title,
    required String content,
    String? confirmButtonText,
    Color? confirmButtonColor,
    String? cancelButtonText,
    Color? cancelButtonColor,
    TextStyle? contentTextStyle,
    Function? onConfirmed,
    Function? onClosed,
    bool? isConfirmDialog = false,
  }) {
    Get.generalDialog(
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
      transitionDuration: const Duration(),
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: kHorizontalContentPadding),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 30,
            ),
            child: Text(
              content,
              style: contentTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 20,
            left: kHorizontalContentPadding,
            right: kHorizontalContentPadding,
          ),
          buttonPadding: EdgeInsets.zero,
          actions: <Widget>[
            TextButton(
              child: Text(
                cancelButtonText ?? 'OK',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                if (onClosed != null) {
                  onClosed();
                } else {
                  Get.back();
                }
              },
            ),
            if (isConfirmDialog!)
              TextButton(
                child: Text(
                  confirmButtonText ?? 'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: confirmButtonColor ?? Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  if (onConfirmed != null) {
                    Get.back();
                    onConfirmed();
                  } else {
                    Get.back();
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
