import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:demo_app/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
textFormFieldEmail(context, title, onSaved, {value}) {
  return TextFormField(
    initialValue: value ?? "",
    keyboardType: TextInputType.emailAddress,
    onSaved: onSaved,
    validator: (value) {
      return validateEmailAddress(context, value);
    },
    style: helveticaWBMedium(context),
    decoration: InputDecoration(
      prefixIcon: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 9),
        width: 62,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.email, color: getWBColor(context))],
        ),
      ),
      labelStyle: helveticaWBMedium(context),
      labelText: getTranslate(context, title),
      errorStyle: helveticaWBLSmall(context),
      errorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      contentPadding: EdgeInsets.all(10),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
    ),
  );
}

TextFormField textFormFieldName(context, title, onSaved, {value}) {
  return TextFormField(
    initialValue: value ?? "",
    keyboardType: TextInputType.text,
    onSaved: onSaved,
    validator: (value) {
      return validateName(context, value);
    },
    style: helveticaWBMedium(context),
    decoration: InputDecoration(
      prefixIcon: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 9),
        width: 62,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.person, color: getWBColor(context))],
        ),
      ),
      // suffix: isLoading
      //     ? Container(child: CircularProgressIndicator(), height: 20, width: 20)
      //     : InkWell(
      //         onTap: isNameTab,
      //         child: Icon(Icons.done, color: getWBColor(context))),
      labelStyle: helveticaWBMedium(context),
      labelText: getTranslate(context, title),
      errorStyle: helveticaWBLSmall(context),
      errorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      contentPadding: EdgeInsets.all(10),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
    ),
  );
}

TextFormField textFormFieldPassword(
    context, title, isOpenPass, isOpenPassMethod, onSaved,
    {value}) {
  return TextFormField(
    obscureText: isOpenPass,
    initialValue: value ?? "",
    keyboardType: TextInputType.text,
    onSaved: onSaved,
    validator: (value) {
      return validatePassword(context, value);
    },
    style: helveticaWBMedium(context),
    decoration: InputDecoration(
      prefixIcon: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 9),
        width: 62,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.password, color: getWBColor(context))],
        ),
      ),
      suffixIcon: InkWell(
          onTap: isOpenPassMethod,
          child: isOpenPass
              ? Icon(Icons.remove_red_eye_outlined, color: getWBColor(context))
              : Icon(Icons.remove_red_eye, color: getWBColor(context))),
      labelStyle: helveticaWBMedium(context),
      labelText: getTranslate(context, title),
      errorStyle: helveticaWBLSmall(context),
      errorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      contentPadding: EdgeInsets.all(10),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
    ),
  );
}

TextFormField textMobileFormField(context, title, String? countryCode,
    Function(Country? country) onCountryChanged, onSaved,
    {value}) {
  return TextFormField(
    initialValue: value ?? "",
    keyboardType:
        TextInputType.numberWithOptions(signed: false, decimal: false),
    onSaved: onSaved,
    validator: (value) {
      return validateMobile(context, value);
    },
    style: helveticaWBMedium(context),
    decoration: InputDecoration(
      // suffix: isLoading
      //     ? Container(child: CircularProgressIndicator(), height: 20, width: 20)
      //     : InkWell(
      //         onTap: isPhoneTab,
      //         child: primarySmallBotton(context, 'UPDATE', () {}, isLoading)),
      prefixIcon: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                child: CountryPickerDialog(
                    titlePadding: EdgeInsets.all(8.0),
                    searchCursorColor: getWBColor(context),
                    searchInputDecoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.search, color: getWBColor(context)),
                      labelStyle: helveticaWBMedium(context),
                      labelText: getTranslate(context, "SEARCH"),
                      contentPadding: EdgeInsets.all(10),
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(color: getWBColor(context)),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: getWBColor(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: getWBColor(context)),
                      ),
                    ),
                    isSearchable: true,
                    onValuePicked: onCountryChanged,
                    itemBuilder: _buildDropdownItem)),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 9),
          width: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                countryCode.toString(),
                style: helveticaWBMedium(context),
                textAlign: TextAlign.center,
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 17, color: getWBColor(context))
            ],
          ),
        ),
      ),
      labelStyle: helveticaWBMedium(context),
      labelText: getTranslate(context, title),
      errorStyle: helveticaWBLSmall(context),
      errorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      contentPadding: EdgeInsets.all(10),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
    ),
  );
}

Widget _buildDropdownItem(Country country) => Container(
      child: Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(
            width: 8.0,
          ),
          Text("+${country.phoneCode}(${country.isoCode})"),
        ],
      ),
    );

textField(context, title, value, icon) {
  return TextFormField(
    initialValue: value,
    readOnly: true,
    style: helveticaWBMedium(context),
    decoration: InputDecoration(
      prefixIcon: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 9),
        width: 62,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, color: getWBColor(context))],
        ),
      ),
      labelStyle: helveticaWBMedium(context),
      labelText: getTranslate(context, title),
      errorStyle: helveticaWBLSmall(context),
      contentPadding: EdgeInsets.all(10),
      errorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
    ),
  );
}

textFieldWithText(context, title, icon, onSaved) {
  return TextFormField(

    style: helveticaWBMedium(context),
    onSaved: onSaved,
    decoration: InputDecoration(
      prefixIcon: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 9),
        width: 62,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, color: getWBColor(context))],
        ),
      ),
      labelStyle: helveticaWBMedium(context),
      labelText: getTranslate(context, title),
      contentPadding: EdgeInsets.all(10),
      errorBorder: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: getWBColor(context)),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: getWBColor(context)),
      ),
    ),
  );
}

textFieldWithout(context, value, hint) {
  return TextFormField(
    initialValue: value,
    style: helveticaWSmall(context),
    decoration: InputDecoration(
      hintText: getTranslate(context, hint),
      hintStyle: helveticaWSmall(context),
    ),
  );
}
