import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class JdButton extends StatelessWidget {

  final Color color;
  final String text;
  // final Function()? cb;    //注意：新版flutter中cb的类型为Function()?   或者也可以定义成var
  var cb;
  final double height;
  JdButton({Key? key,this.color=Colors.black,this.text="按钮",this.cb=null,this.height=68}) : super(key: key);

  @override
  Widget build(BuildContext context) {   
    return InkWell(
      onTap: this.cb,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        height: ScreenAdapter.height(this.height),
        width: double.infinity,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            "${text}",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
