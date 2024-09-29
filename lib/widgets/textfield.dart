import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lukafulu/widgets/constantes.dart';

buildTextField(
  BuildContext context, {
  required TextEditingController controller,
  required String placeholder,
  required bool isNumber,
  bool obscureText = false,
  Widget? prefix,
  Widget? suffix,
  String? errorText,
  Function(String)? onChanged, // Ajout de la fonction de rappel onChanged
}) {
  return isNumber
      ? SizedBox(
          height: 50, // Adjusted height to accommodate country picker
          child: Row(
            children: [
              // Container(
              //
              //   padding: EdgeInsets.zero,
              //   margin: EdgeInsets.zero,
              //   height: 50.0,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     // border: Border.all(
              //     //   color: Colors.grey,
              //     // ),
              //     borderRadius: borderRadius,
              //   ),
              //   child: CountryCodePicker(
              //     onChanged: (country) {
              //       onChanged;
              //     },
              //     flagWidth: 25,
              //     padding: EdgeInsets.zero,
              //     initialSelection: 'CD', // Default to France, adjust as needed
              //     favorite: ['+243', 'CD'],
              //     showFlag: true,
              //     showCountryOnly: false,
              //     alignLeft: false,
              //   ),
              // ),
              sizedbox2,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius
                  ),
                  height: 50.0,
                  child: CupertinoTextField(
                    padding: EdgeInsets.only(left: 15),
                    controller: controller,
                    placeholder: 'Entrée votre Numéro',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      // border: Border.all(
                      //     color: errorText != null ? Colors.red : Colors.grey),
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        )
      : Container(

          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: borderRadius
          ),
          height: 50,
          child: CupertinoTextField(
            padding: EdgeInsets.only(left: 15),
            controller: controller,
            placeholder: placeholder,
            obscureText: obscureText,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
            prefix: prefix,
            suffix: suffix,

            decoration: BoxDecoration(
              borderRadius: borderRadius,
              // border: Border.all(
              //     color: errorText != null ? Colors.red : Colors.grey),
            ),
            onChanged:
                onChanged, // Utilisation de la fonction de rappel onChanged
          ),
        );
}
