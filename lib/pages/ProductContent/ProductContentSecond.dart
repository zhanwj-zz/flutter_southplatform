import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../widget/LoadingWidget.dart';
class ProductContentSecond extends StatefulWidget {

  final List _productContentList;
  ProductContentSecond(this._productContentList,{Key? key}) : super(key: key);

  _ProductContentSecondState createState() => _ProductContentSecondState();
}

class _ProductContentSecondState extends State<ProductContentSecond> with AutomaticKeepAliveClientMixin{

  var _flag=true;
  var _id;
  bool get wantKeepAlive => true;
  @override
  void initState() { 
    super.initState();
    this._id=widget._productContentList[0].sId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
        children: [
          this._flag ? LoadingWidget() : Text(""),
          Expanded(
            child: InAppWebView(
              //老版本：initialUrl    新版本：initialUrlRequest
              initialUrlRequest:URLRequest(url: Uri.parse("https://jdmall.itying.com/pcontent?id=${this._id}")),
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                print(progress / 100);

                if (progress / 100 > 0.9999) {
                  setState(() {
                    this._flag = false;
                  });
                }
              },
          ))
        ],
      ),
    );
  }
}