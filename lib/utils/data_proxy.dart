/*
* 数据传输代理
*/
import 'package:flutter/widgets.dart';
import 'package:flutter_nb/database/database_control.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/object_util.dart';

class DataProxy {
  static final DataProxy _dataProxy = new DataProxy._init();
  BuildContext _context;
  Operation _operation;

  static DataProxy build() {
    return _dataProxy;
  }

  DataProxy._init();

  void setContext(BuildContext context, Operation operation) {
    _context = context;
    _operation = operation;
  }

  /*
  * 启动与原生的交互
  */
  void connect(BuildContext context) {
    _context = context;
    InteractNative.dealNativeWithValue(_onEvent, onError: _onError);
  }

/*
  * 断开与原生的交互
  */
  void unConnect() {
    if (null != InteractNative.streamSubscription) {
      InteractNative.streamSubscription.cancel();
    }
  }

  void _onEvent(Object event) {
    if (event == null || !(event is Map)) {
      return;
    }
    Map res = event;
    if (res.containsKey('string')) {
      if (res.containsValue('onConnected')) {
        //已连接
      } else if (res.containsValue('user_removed')) {
        //显示帐号已经被移除
        DialogUtil.buildToast('flutter帐号已经被移除');
        ObjectUtil.doExit(_context);
      } else if (res.containsValue('user_login_another_device')) {
        //显示帐号在其他设备登录
        DialogUtil.buildToast('flutter帐号在其他设备登录');
        ObjectUtil.doExit(_context);
      } else if (res.containsValue('disconnected_to_service')) {
        //连接不到聊天服务器
//        DialogUtil.buildToast('连接不到聊天服务器');
      } else if (res.containsValue('no_net')) {
        //当前网络不可用，请检查网络设置
        DialogUtil.buildToast('当前网络不可用，请检查网络设置');
      } else if (res.containsValue('onDestroy')) {
        //APP执行onDestroy
        unConnect();
      }
    } else if (res.containsKey('json')) {
      DataBaseControl.decodeData(res.values.elementAt(0),
          context: _context,
          operation: _operation, callBack: (type, unReadCount, entity) async{
        entity.isUnreadCount = unReadCount;
        //触发点MessageState
        InteractNative.getMessageEventSink().add(entity);
      }); //解析数据保存数据库
    }
  }

  void _onError(Object error) {
    DialogUtil.buildToast(error.toString());
  }
}
