import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide Action',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Slide Action'),
    );
  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements SlideActionCallback {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SlideAction(slideActionCallback: this),
    )
    );
  }

  @override
  onSlideComplete(){
    print("Slide completed");
  }
}

class SlideAction extends StatefulWidget {
  final ValueChanged<double> valueChanged;
  final SlideActionCallback slideActionCallback;

  SlideAction({this.valueChanged, @Key("slideActionCallback") this.slideActionCallback});

  @override
  SliderState createState() {
    return new SliderState();
  }

  slideActionComplete(){
    slideActionCallback.onSlideComplete();
  }
}

class SliderState extends State<SlideAction> {
  ValueNotifier<double> valueListener = ValueNotifier(.0);
  static const SLIDE_THRESHOLD = 0.9;
  
  @override
  void initState() {
    valueListener.addListener(notifyParent);
    super.initState();
  }

  void notifyParent() {
    if (widget.valueChanged != null) {
      widget.valueChanged(valueListener.value);
    }
  }

  void notifySlideActionComplete(){
      widget.slideActionCallback.onSlideComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
      child: Container(
        height: 30.0,
        margin: EdgeInsets.only(right: 20.0, left: 20.0),
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Text("Slide to complete",
                    style: TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.w300))),
            Builder(
              builder: (context) {
                final handle = GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (valueListener.value >= 0.9) {
                        valueListener.value = 0.toDouble();
                        notifySlideActionComplete();
                      }else{
                        valueListener.value = 0.toDouble();
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      valueListener.value = (valueListener.value +
                              details.delta.dx / context.size.width)
                          .clamp(.0, 1.0);
                    },
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 1.0)
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                    ));

                return AnimatedBuilder(
                  animation: valueListener,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment(valueListener.value * 2 - 1, .5),
                      child: child,
                    );
                  },
                  child: handle,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

abstract class SlideActionCallback{
  onSlideComplete();
}