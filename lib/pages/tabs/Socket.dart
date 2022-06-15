import 'package:flutter/material.dart';
import '../../widget/JdText.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../services/ScreenAdapter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class SocketPage extends StatefulWidget {
  SocketPage({Key? key}) : super(key: key);

  @override
  _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  TextEditingController _message = TextEditingController();
  late IO.Socket socket;
  List messageList = [];
  bool showPhotoAction = false;
  //新版本的image_picker需要实例化ImagePicker
  final picker = ImagePicker();
  @override
  // TODO: implement wantKeepAlive  缓存当前页面
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    //注意分组
    this.socket = IO.io('http://10.11.146.91:3000?roomid=1', <String, dynamic>{
      'transports': ['websocket']
    });

    this.socket.on('connect', (_) {
      print('connect..');
    });

    this.socket.on('toClient', (data) {
      setState(() {
        this.messageList.add({
          "server":true,
          "title":data["title"],
          "url":data["url"]
        });
      });
      //改变滚动条的位置
      this
          ._scrollController
          .jumpTo(_scrollController.position.maxScrollExtent + 80);
    });
  }

  //广播
   _doEmit(value) async {
     this.socket.emit('toServer', {"title": value, "url": ""});   
    setState(() {
      //更新本地数据
      this.messageList.add({"server": false, 'title': value, 'url': ""});
    });
    this._scrollController.jumpTo(_scrollController.position.maxScrollExtent + 80);

  }

//  /*拍照*/
//   _takePhoto() async {
//     var image =
//         await picker.getImage(source: ImageSource.camera, maxWidth: 400);

//     this._uploadImage(image);
//   }

//   /*相册*/
//   _openGallery() async {
//     var image =
//         await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 400);
//     this._uploadImage(image);
//   }

  /*拍照*/
  _takePhoto() async {
    // picker定义在属性里面了
    final pickedFile = await picker.getImage(source: ImageSource.camera, maxWidth: 400);
    if(pickedFile!=null){
       this._uploadImage(File(pickedFile.path));
    }else{
      print("error:getImage is null");
    }
  }

  /*相册*/
  _openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, maxWidth: 400);
    if(pickedFile!=null){
       this._uploadImage(File(pickedFile.path));
    }else{
      print("error:getImage is null");
    }
    
  }

   //上传图片
  _uploadImage(File _imageDir) async {
    
    //注意：dio3.x以后的版本为了兼容web做了一些修改，上传图片的时候需要把File类型转换成String类型，具体代码如下   
    setState(() {
      //更新数据
      this.messageList.add({"server": false, 'title': "", "url": _imageDir});
    });


    var fileDir=_imageDir.path;  
    FormData formData = FormData.fromMap({   
      "file":  await MultipartFile.fromFile(fileDir, filename: "xxx.jpg")     
    });
    var response = await Dio().post("http://10.11.146.91:3000/imgupload", data: formData);
    
    var data=response.data;
    var url = "http://10.11.146.91:3000${data["path"]}";    
    this.socket.emit('toServer', {"title": '', "url": url});
    this._scrollController.jumpTo(_scrollController.position.maxScrollExtent + 80);
    //隐藏键盘
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() { //注意
       this.showPhotoAction = false;
    });
   
    
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(
        title: Text("实时聊天测试（未完善）"),
      ),     
      body: Stack(
        children: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.only(
                bottom: 100
              ),
              child: ListView.builder(
                controller: this._scrollController,
                itemCount: this.messageList.length,
                itemBuilder: (context, index) {
                  if(this.messageList[index]['server']){
                    var w;
                    if(this.messageList[index]["url"] != ""){
                        w=Container(
                          alignment: Alignment.centerRight,
                          width: 100,
                          height: 100,
                          child: Image.network(this.messageList[index]["url"]),
                        );
                    }else{
                        w=Text("${this.messageList[index]['title']}",textAlign: TextAlign.end,);
                    }                    
                    return ListTile(
                      trailing:Icon(Icons.people),
                      title: w
                    );

                  }else{
                    var w;
                    if(this.messageList[index]["url"] != ""){
                        w=Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          height: 100,
                          child: Image.file(this.messageList[index]["url"]),  //注意写法
                        );
                    }else{
                        w=Text("${this.messageList[index]['title']}");
                    }                    
                    return ListTile(
                      leading:Icon(Icons.people),
                      title: w
                    );
                  }

                },
              ),
            ),
            onTap: (){
              setState(() {
                 this.showPhotoAction=false;
                 //隐藏键盘
                 FocusScope.of(context).requestFocus(FocusNode());
              });
            },
          ),
          Positioned(
            bottom: 0,
            //注意使用ScreenAdapter 还需要 main.dart中调用 ScreenUtilInit
            width: ScreenAdapter.width(750),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              width: ScreenAdapter.width(750),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: JdText(
                          controller:_message,
                          onChanged: (value){
                              _message.text=value;
                          },
                          onSubmitted:(key){
                             this._doEmit(_message.text);
                             _message.text='';
                          } ,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenAdapter.width(20)),
                        child: Container(
                          width: ScreenAdapter.width(68),
                          height: ScreenAdapter.width(68),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.circular(ScreenAdapter.width(68)),
                          ),
                          child: InkWell(
                            child: Icon(Icons.add),
                            onTap: () {
                              setState(() {
                                this.showPhotoAction = !this.showPhotoAction;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  this.showPhotoAction
                      ? Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {
                                  this._takePhoto();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.photo_library),
                                onPressed: () {
                                  this._openGallery();
                                },
                              ),
                            )
                          ],
                        )
                      : Container(height: 0)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
