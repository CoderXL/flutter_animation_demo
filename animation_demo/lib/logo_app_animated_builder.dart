//AnimatedBuilder
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogoAppBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LogoAppState();
  }
}

//logo
Widget ImageLogo = new Image(
  image: new AssetImage('images/logo.png'),
);

class GrowTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  GrowTransition({this.child, this.animation});
  static final _opacityTween = new Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = new Tween<double>(begin: 0.0, end: 200.0);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("动画demo"),
        ),
        body: new Center(
          child: new AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return new Opacity(
                opacity: _opacityTween.evaluate(animation),
                child: new Container(
                  //宽和高都是根据animation的值来变化
                  height: _sizeTween.evaluate(animation),
                  width: _sizeTween.evaluate(animation),
                  child: child,
                ),
              );
            },
            child: child,
          ),
        ),
      ),
    );
  }
}

class _LogoAppState extends State<LogoAppBuilder>
    with SingleTickerProviderStateMixin {
  //动画的状态，如动画开启，停止，前进，后退等
  Animation<double> animation;

  //管理者animation对象
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //创建AnimationController
    //需要传递一个vsync参数，存在vsync时会防止屏幕外动画（
    //译者语：动画的UI不在当前屏幕时）消耗不必要的资源。 通过将SingleTickerProviderStateMixin添加到类定义中，可以将stateful对象作为vsync的值。
    controller = new AnimationController(
      //时间是3000毫秒
      duration: const Duration(milliseconds: 3000),
      //vsync 在此处忽略不必要的情况
      vsync: this,
    );
    //新增
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        //如果动画完成了
        if (state == AnimationStatus.completed) {
          //开始反向这动画
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          //开始向前运行着动画
          controller.forward();
        }
      }); //添加监听器
    //只显示动画一次
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new GrowTransition(child: ImageLogo, animation: animation);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //资源释放
    controller.dispose();
  }
}
