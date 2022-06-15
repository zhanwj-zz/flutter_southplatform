import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../services/ScreenAdapter.dart';

class JdText extends StatelessWidget {

  final String text;
  final bool password;
  final Function(String)? onChanged;   // Function(String) 是onChanged方法的类型
  final Function(String)? onSubmitted;
  final int maxLines;
  final double height;
  final TextEditingController? controller;

  // ignore: avoid_init_to_null
  JdText({Key? key,this.text="输入内容",this.password=false,this.onChanged=null,this.onSubmitted=null,this.maxLines=1,this.height=68,this.controller=null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller:controller,
        maxLines:this.maxLines ,
        obscureText: this.password,
        decoration: InputDecoration(
            hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: this.onChanged,
        onSubmitted: this.onSubmitted,
      ),
      height: ScreenAdapter.height(this.height),
      decoration: BoxDecoration(      
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black12
            )
          )
    ),
    );
  }
}
