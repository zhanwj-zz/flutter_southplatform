import 'package:event_bus/event_bus.dart';


//Bus 初始化 

EventBus eventBus = EventBus();

//商品详情广播数据
class ProductContentEvent{
  late String str;
  ProductContentEvent(String str){
    this.str=str;
  }
}

//用户中心广播
class UserEvent{
  String str;
  UserEvent(this.str);
}

//收货地址广播
class AddressEvent{
  String str;
  AddressEvent(this.str);
}

//结算页面
class CheckOutEvent{
  String str;
  CheckOutEvent(this.str);
}



