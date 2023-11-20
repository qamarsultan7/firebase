import 'package:flutter/material.dart';

class Utils {
  static SnackBar createSnackBar(String message,Color colour,Icon icon) {
    return SnackBar(
      content: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(message,overflow: TextOverflow.ellipsis,maxLines: 1,)),
          const SizedBox(width: 50,),
          icon
        ],
      )),
      margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 30),
      padding: const EdgeInsets.all(15),
      backgroundColor:colour,
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      dismissDirection: DismissDirection.startToEnd,
    );
  }
  void SignUpAuth(){
    
  }
}
