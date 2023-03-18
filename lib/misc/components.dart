import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/constants.dart';

class Components{

  Widget customTextFormField({
    String? labelText,
    String? initialValue,
    String? Function(String?)? validator,
    TextAlign? textAlign,
    TextStyle? style,
    Function(String?)? onSaved,
    bool obscureText = false,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left!,top!,right!,bottom!),
      child: TextFormField(
        style: style,
        textAlign: textAlign ?? TextAlign.start,
        initialValue: initialValue,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          fillColor: Colors.white,
        ),
        obscureText: obscureText,
        onChanged: (value) {
          value = value.trim();
          value = value.replaceAll(RegExp(r'\s+'), ' ');
          // print(value);
        },
      ),
    );
  }

  Widget searchBarTextButton({
    required String? buttonName,
    required Color? color,
    required void Function()? onPressed,
  }){
    return SizedBox(
      height: 24,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        ),
        onPressed: onPressed, 
        child: Text(
          buttonName!,
          style: TextStyle(
            color: color,
            fontSize: Constants.textM
          )
        )
      ),
    );
  }

  Widget cTabBar({
    required List<Widget> tabs
  }){
    return TabBar(
      indicatorWeight: 1.5,
      labelStyle: TextStyle(fontSize: Constants.textM),
      isScrollable: true,
      tabs: tabs
    );
  }

  Widget cTab({
    required String? text
  }){
    return Tab(text: text, height: 30);
  }

  Widget cEduDialogTitle({
    String? title
  }){
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color.fromRGBO(227, 227, 227, 1)
          )
        )
      ),
      child: Text(title!, textAlign: TextAlign.center, style: TextStyle(
        fontSize: Constants.textXL, fontWeight: FontWeight.w600
      ),)
    );
  }

  Widget cEduDialogContent({
    Key? key,
    required List<Widget> children
  }){
    return Form(
      key: key, 
      child: Column(
        children: children
      )
    );
  }

  Widget cTextFormField1({
    String? hintText,
    String? labelText,
    String? initialValue,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
  }){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,2,8,2),
      child: TextFormField(
        initialValue: initialValue,
        onSaved: onSaved,
        maxLines: 1,
        minLines: 1,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: Constants.textM
          ),
          labelStyle: TextStyle(
            fontSize: Constants.textM
          ),
          contentPadding: const EdgeInsets.fromLTRB(12,1,12,1),
          hintText: hintText,
          filled: true,
          labelText: labelText,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6)),                      
          ),
          fillColor: lightColorScheme.onPrimary
        ),
        style: TextStyle(
          fontSize: Constants.textM
        ),
        onChanged: (value) {
          value = value.trim();
          value = value.replaceAll(RegExp(r'\s+'), ' ');
          // print(value);
        },
      )
    );    
  }

  Widget cTextFormField2({
    String? hintText,
    String? labelText,
    String? initialValue,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
  }){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,2,8,2),
      child: TextFormField(
        initialValue: initialValue,
        onSaved: onSaved,
        maxLines: 15,
        minLines: 1,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: Constants.textM
          ),
          labelStyle: TextStyle(
            fontSize: Constants.textM
          ),
          contentPadding: const EdgeInsets.fromLTRB(12,1,12,1),
          hintText: hintText,
          filled: true,
          labelText: labelText,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6)),                      
          ),
          fillColor: lightColorScheme.onPrimary
        ),
        style: TextStyle(
          fontSize: Constants.textM
        ),
        onChanged: (value) {
          value = value.trim();
          value = value.replaceAll(RegExp(r'\s+'), ' ');
          // print(value);
        },
      )
    );
  }
  
  



  Widget textFieldItem({
    String? labelText,
    TextEditingController? controller,
    required bool isDate,
    bool? validator,
    void Function()? onTap,
    String? textResult,
    TextAlign? textAlign
  }){
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          border: Border(bottom: Constants.borderSideSoft)
        ),
        child: isDate?
        Container(
          padding: const EdgeInsets.only(left: 4,right: 4,bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(labelText!,style: TextStyle(
                    fontSize: Constants.textSL,
                    fontWeight: FontWeight.normal
                  )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                        textResult!,
                        style: TextStyle(fontSize: Constants.textL,),
                      )
                  ),
                ],
              ),
            ],
          ),
        ):
        TextField(
          textAlign: textAlign ?? TextAlign.end,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            fillColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: Constants.textSL,
            )
          ),
          style: TextStyle(
            fontSize: Constants.textL,
          ),
          onChanged: (value) {
            value = value.trim();
            value = value.replaceAll(RegExp(r'\s+'), ' ');
            // print(value);
          },
        ),
      ),
    );
  }

  Widget textTypeAheadField<T>({
    String? labelText,
    TextEditingController? controller,
    EdgeInsetsGeometry? margin,
    bool? validator,
    required FutureOr<Iterable<T>> Function(String) suggestionsCallback,
    required Widget Function(BuildContext, T) itemBuilder,
    required void Function(T) onSuggestionSelected
  }){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Container(
        margin: margin,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: TypeAheadField<T>(
          textFieldConfiguration: TextFieldConfiguration(
            textAlign: TextAlign.end,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText!,
              border: InputBorder.none,
              fillColor: Colors.white,
            ),
            style: TextStyle(
              fontSize: Constants.textL,
            ),
            onChanged: (value) {
              value = value.trim();
              value = value.replaceAll(RegExp(r'\s+'), ' ');
              // print(value);
            },
          ),
          suggestionsCallback: suggestionsCallback, 
          itemBuilder: itemBuilder,
          onSuggestionSelected: onSuggestionSelected
        )
      ),
    );
  }


  Widget drawerItem({
    String? text,
    IconData? icon,
    void Function()? onTap,
  }){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(text!, textAlign: TextAlign.center, 
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Constants.textM,
            ),
          ),
        ),
      )
    );
  }
  
  Widget chatAppBar({
    String? title,
    void Function()? onTap
  }){
    return SizedBox(
      height: kToolbarHeight, 
      child: Row(
        children: [
          Expanded(flex: 1, 
            child: GestureDetector(
              child: const Icon(Icons.arrow_back_ios_new),
              onTap: onTap,
            )
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(title!,
                style: TextStyle(
                  fontSize: Constants.textXL, 
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
      ],
      )
    );
  }

  Widget hiddenDrawer({
    Widget? child,
    double? width
  }){
    return SafeArea(
      child: Container(
        width: width!,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 64),
        child:child
      )
    );
  }

  Widget convoListItem({
    List<String?>? othersName,
    List<String?>? othersId,
    List<String?>? convoId,
    int? itemCount,
    String? itemName,
    String? itemLastMessage,
    List<Widget>? timestamp
  }){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: Constants.borderSideSoft,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemCount,
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      final len = itemCount!;
                      return index != len - 1
                      ? Text(
                        "${itemName![index]}, ",
                        style:
                          TextStyle(fontSize: Constants.textM),
                      )
                      : Text(
                        itemName![index],
                        style:
                          TextStyle(fontSize: Constants.textSL),
                      );
                    },
                  ),
                ),
                Text(
                  itemLastMessage!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Constants.textM,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: timestamp!,
            )
          )
        ],
      ),
    );
  }

  Widget profileIcon50({
    dynamic condition,
    String? name
  }){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const ShapeDecoration(
            shape: StarBorder.polygon(
              sides: 6,
              pointRounding: 0.4,
            ),
            color: Colors.black
          ),
        ),
        condition==null? Text(
          name!,
          style: TextStyle(
            fontSize: Constants.textS
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ):
        condition? Text(
          name!,
          style: TextStyle(
            fontSize: Constants.textS
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ):
        const Text(
          "You"
        )
      ],
    );
  }

  static Widget tweenAnimatedBody({
    required double screenWidth,
    required double offsetTweenValue,
    required double scaleTweenValue,
    required double matrixTweenValue,
    required Widget body,
  }){
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: offsetTweenValue), 
      duration: const Duration(milliseconds: 200), 
      builder: (context , val, widget){
        return Transform.translate(
          offset: Offset(-(screenWidth*val), 0),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: scaleTweenValue),
            duration: const Duration(milliseconds: 200), 
            builder:(context , scale, widget) {
              return Transform.scale(
                scale: scale,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: matrixTweenValue),
                  duration: const Duration(milliseconds: 200), 
                  builder:(context , rotate, widget) {
                    return Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      // ..rotateX(-rotate*1.5)
                      ..rotateY(-rotate)
                      // ..rotateZ(rotate)
                      ,
                      child: body
                    );
                  }
                )
              );
            }
          ),
        );
      }
    );
  }
}