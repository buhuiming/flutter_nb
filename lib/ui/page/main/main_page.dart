import 'package:flutter/material.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/resource/colors.dart';
import 'package:flutter_nb/ui/page/base/theme_state.dart';
import 'package:flutter_nb/ui/page/login_page.dart';
import 'package:flutter_nb/ui/page/main/found_page.dart';
import 'package:flutter_nb/ui/page/main/friends_page.dart';
import 'package:flutter_nb/ui/page/main/message_page.dart';
import 'package:flutter_nb/ui/page/main/mine_page.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/ui/widget/more_widgets.dart';
import 'package:flutter_nb/utils/data_proxy.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/file_util.dart';
import 'package:flutter_nb/utils/interact_vative.dart';
import 'package:flutter_nb/utils/notification_util.dart';
import 'package:flutter_nb/utils/object_util.dart';
import 'package:permission_handler/permission_handler.dart';

/*
*  主页
*/
class MainPage extends StatelessWidget {
  final bool isShowLogin;

  MainPage({Key key, this.isShowLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceUtil.setBarStatus(true);
    return MyHomePage(isShowLogin: isShowLogin);
  }
}

class MyHomePage extends StatefulWidget {
  final bool isShowLogin;
  MyHomePage({Key key, this.isShowLogin}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*
* 如果子页面是继承StatefulWidget和State，则子页面的State要有with AutomaticKeepAliveClientMixin且
* bool get wantKeepAlive => true;父页面（此页面），要有with SingleTickerProviderStateMixin(多个动画
* 效果的则用TickerProviderStateMixin)，才能保证页面切换，不刷新重置；单一页面不需要刷新，bool get wantKeepAlive => false;
*
* 如果子页面是普通的Widget，则父页面（此页面），要有with AutomaticKeepAliveClientMixin且，且
* bool get wantKeepAlive => true;才能保证页面切换，不刷新重置；
*/
class _MyHomePageState extends ThemeState<MyHomePage>
    with SingleTickerProviderStateMixin {
  final Operation operation = new Operation();
  var _pageController = new PageController(initialPage: 0);
  bool _isShowLogin;
  bool _buildMain = false;
  int _tabIndex = 0;
  var appBarTitles = ['消息', '朋友', '发现', '我的'];
  /*
   * 存放4个页面，跟fragmentList一样
   */
  List _pageList;

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 13.0, color: primarySwatch));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 13.0, color: ColorT.text_gray));
    }
  }

  void initData() {
    /*
     * 4个子界面
     */
    _pageList = [
      new MessagePage(operation: operation, rootContext: context),
      new FriendsPage(operation: operation, rootContext: context),
      new FoundPage(operation: operation, rootContext: context),
      new MinePage(operation: operation, rootContext: context)
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPermission();
    _isShowLogin = widget.isShowLogin;
    _buildMain = !widget.isShowLogin;
    initData();
  }

  _getPermission(){
    //请求读写权限
    ObjectUtil.getPermissions([PermissionGroup.storage]).then((res) {
      if (res[PermissionGroup.storage] == PermissionStatus.denied ||
          res[PermissionGroup.storage] == PermissionStatus.disabled ||
          res[PermissionGroup.storage] == PermissionStatus.unknown) {
        //用户拒绝，禁用，或者不可用
        DialogUtil.showBaseDialog(context, '获取不到读写权限，APP不能正常使用',
            right: '去设置', left: '取消', rightClick: (res) {
              PermissionHandler().openAppSettings();
            });
      } else if (res[PermissionGroup.storage] == PermissionStatus.granted) {
        //用户同意，创建文件夹
        InteractNative.goNativeWithValue(
            InteractNative.methodNames['createFiles'], null);
      } else if (res[PermissionGroup.storage] == PermissionStatus.restricted) {
        //用户同意IOS的回调

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //NotificationUtil中的context是Login的，此处要替换全局
    NotificationUtil.instance().build(context, operation);
    DataProxy.build().setContext(context, operation);
    return MaterialApp(
        theme: ThemeData(
            primaryColor: primaryColor,
            primarySwatch: primarySwatch,
            platform: TargetPlatform.iOS),
        home: Stack(children: <Widget>[
          //为什么登录页面要改成和主页放到一起？因为登录成功时，环信IM即刻推送未登录时收到的消息，而
          //此时主页还未初始化，会导致主页消息不能刷新。
          Offstage(offstage: !_isShowLogin, child: LoginPage()),
          Offstage(
              offstage: _isShowLogin,
              child: _buildMain != true
                  ? Scaffold(
                      body: MoreWidgets.buildNoDataPage(),
                    )
                  : new LoadingScaffold(
                      //使用有Loading的widget
                      operation: operation,
                      isShowLoadingAtNow: false,
                      child: new WillPopScope(
                        onWillPop: () {
                          _backPress(); //物理返回键，返回到桌面
                        },
                        child: Scaffold(
                            body: new PageView.builder(
                              onPageChanged: _pageChange,
                              controller: _pageController,
                              itemBuilder: (BuildContext context, int index) {
                                return _pageList[index];
                              },
                              itemCount: 4,
                            ),
                            bottomNavigationBar: new BottomNavigationBar(
                              items: <BottomNavigationBarItem>[
                                new BottomNavigationBarItem(
                                    icon: _tabIndex == 0
                                        ? Image.asset(
                                            FileUtil.getImagePath('message',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0,
                                            color: primarySwatch)
                                        : Image.asset(
                                            FileUtil.getImagePath('message',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0),
                                    title: getTabTitle(0)),
                                new BottomNavigationBarItem(
                                    icon: _tabIndex == 1
                                        ? Image.asset(
                                            FileUtil.getImagePath('friends',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0,
                                            color: primarySwatch)
                                        : Image.asset(
                                            FileUtil.getImagePath('friends',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0),
                                    title: getTabTitle(1)),
                                new BottomNavigationBarItem(
                                    icon: _tabIndex == 2
                                        ? Image.asset(
                                            FileUtil.getImagePath('more',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0,
                                            color: primarySwatch)
                                        : Image.asset(
                                            FileUtil.getImagePath('more',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0),
                                    title: getTabTitle(2)),
                                new BottomNavigationBarItem(
                                    icon: _tabIndex == 3
                                        ? Image.asset(
                                            FileUtil.getImagePath('mine',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0,
                                            color: primarySwatch)
                                        : Image.asset(
                                            FileUtil.getImagePath('mine',
                                                dir: 'main_page',
                                                format: 'png'),
                                            width: 22.0,
                                            height: 22.0),
                                    title: getTabTitle(3)),
                              ],
                              type: BottomNavigationBarType.fixed,
                              //默认选中首页
                              currentIndex: _tabIndex,
                              iconSize: 22.0,
                              //点击事件
                              onTap: (index) {
//                      _pageController.animateToPage(index,
//                          duration: const Duration(milliseconds: 120),
//                          curve: Curves.ease);
                                //以上方式，动画过度太明显
                                _pageController.jumpToPage(index);
                              },
                            )),
                      )))
        ]));
  }

  void _pageChange(int index) {
    Constants.currentPage = index;
    setState(() {
      if (_tabIndex != index) {
        _tabIndex = index;
      }
    });
  }

  _backPress() {
    InteractNative.goNativeWithValue(InteractNative.methodNames['backPress']);
  }

  @override
  void notify(Object type) {
    if (type == InteractNative.RESET_THEME_COLOR) {
      setState(() {
        init();
      });
    } else if (type == InteractNative.CHANGE_PAGE_TO_MAIN) {
      //登录成功后，由登录页面切换到主页
      setState(() {
        if (null != _pageList) {
          _pageList.clear();
          initData();
        } else {
          initData();
        }
        _isShowLogin = false;
        _buildMain = true;
      });
    } else if (type == InteractNative.CHANGE_PAGE_TO_LOGIN) {
      //退出登录后，由主页切换到登录页面
      setState(() {
        _isShowLogin = true;
      });
    }
  }
}
