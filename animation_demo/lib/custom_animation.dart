import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _bollView extends CustomPainter {
  //颜色
  Color color;
  //数量
  int count;
  //集合放动画
  List<Animation<double>> ListAnimators;
  _bollView({this.color, this.count, this.ListAnimators});
  @override
  void paint(Canvas canvas, Size size) {
    //绘制流程
    double boll_radius = (size.width - 15) / 8;
    Paint paint = new Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    //因为这个wiaget是80 球和球之间相隔5
    for (int i = 0; i < count; i++) {
      double value = ListAnimators[i].value;
      //确定圆心 半径 画笔
      //第一个球 r
      //第二个球 5 + 3r
      //第三个球 15 + 5r
      //第四个球 30 + 7r
      //半径也是随着动画值改变
      canvas.drawCircle(
          new Offset(
              (i + 1) * boll_radius + i * boll_radius + i * 5, size.height / 2),
          boll_radius * (value > 1 ? (2 - value) : value),
          paint);
    }
  }

  //刷新是否重绘
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class MyBalls extends StatefulWidget {
  Size size;
  Color color;
  int count;
  int seconds;

  //默认四个小球 红色
  MyBalls(
      {this.size,
      this.seconds: 400,
      this.color: Colors.redAccent,
      this.count: 4});
  @override
  State<StatefulWidget> createState() {
    return MyBallsState();
  }
}

//继承TickerProviderStateMixin，提供Ticker对象
class MyBallsState extends State<MyBalls> with TickerProviderStateMixin {
  //动画集合
  List<Animation<double>> animatios = [];
  //控制器集合
  List<AnimationController> animationControllers = [];
  //颜色
  Animation<Color> colors;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.count; i++) {
      //创建动画控制器
      AnimationController animationController = new AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.count * widget.seconds));
      //添加到控制器集合
      animationControllers.add(animationController);
      //颜色随机
      colors = ColorTween(begin: Colors.red, end: Colors.green)
          .animate(animationController);
      //创建动画 每个动画都要绑定控制器
      Animation<double> animation =
          new Tween(begin: 0.1, end: 1.9).animate(animationController);
      animatios.add(animation);
    }
    animatios[0].addListener(() {
      //刷新
      setState(() {});
    });

    //延迟执行
    var delay = (widget.seconds ~/ (2 * animatios.length - 2));
    for (int i = 0; i < animatios.length; i++) {
      Future.delayed(Duration(milliseconds: delay * i), () {
        animationControllers[i]..repeat().orCancel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      //自定义画笔
      painter: _bollView(
          color: colors.value, count: widget.count, ListAnimators: animatios),
      size: widget.size,
    );
  }

  //释放资源
  @override
  void dispose() {
    super.dispose();
    animatios[0].removeListener(() {
      setState(() {});
    });
    animationControllers[0].dispose();
  }
}

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animation demo'),
        ),
        body: Center(
          child: MyBalls(size: new Size(80.0, 20.0)),
        ),
      ),
    );
  }
}
