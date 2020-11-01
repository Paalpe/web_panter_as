import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';



/// A draggable card that moves back to [Alignment.center] when it's
/// released.
class DraggableCard extends StatefulWidget {
  final Widget child;
  DraggableCard({this.child});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



// Mousesense

int _enterCounter = 0;
int _exitCounter = 0;
double x = 0.0;
double y = 0.0;

void _incrementEnter(PointerEvent details) {
  setState(() {
    _enterCounter++;
  });
}
void _incrementExit(PointerEvent details) {
  setState(() {
    _exitCounter++;
  });
}
void _updateLocation(PointerEvent details) {
  setState(() {
    x = details.position.dx;
    y = details.position.dy;
  });
}
//Mouse

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      // onEnter: (details) {
      //     setState(() {
      //       _dragAlignment += Alignment(
      //         details.delta.dx / (size.width/2),
      //         details.delta.dy / (size.height/2),
      //       );
      //     });
      //   },//_incrementEnter,
      onHover: (details) {
          setState(() {
            _dragAlignment += Alignment(
              details.delta.dx / (size.width/2),
              details.delta.dy / (size.height/2),
            );
          });
        },//_increm
      onExit: (details) {
          _runAnimation(details.position, size);
        },
      child: GestureDetector(
        onPanDown: (details) {
          _controller.stop();
        },
        onPanUpdate: (details) {
          setState(() {
            _dragAlignment += Alignment(
              details.delta.dx / (size.width / 2),
              details.delta.dy / (size.height / 2),
            );
          });
        },
        onPanEnd: (details) {
          _runAnimation(details.velocity.pixelsPerSecond, size);
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Align(
            alignment: _dragAlignment,
            child: widget.child,
            
          ),
        ),
      ),
    );
  }
}




class MyAppCards extends StatefulWidget {
  final Size size;
  final bool active;
  final String text;
  final String initText;
  final IconData iconData;
  final Duration offsetBuild;
  const MyAppCards(
      {Key key,
      @required this.active,
      this.text,
      this.iconData,
      @required this.size,
      this.initText,
    @required  this.offsetBuild})
      : super(key: key);

  @override
  _MyAppCardsState createState() => _MyAppCardsState();
}

class _MyAppCardsState extends State<MyAppCards> {
  bool offsetdone= false;
  bool hover = false;


@override
  void initState() {
    Timer(widget.offsetBuild,(){
      setState(() {
      offsetdone=true;
        
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (offsetdone) {
      
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Card(
        elevation: 40,
        child: InkWell(
            hoverColor: Colors.orange[50],
            // mouseCursor: MouseCursor,
            onHover: (h) {
              setState(() {
                hover = !hover;
              });
            },
            onLongPress: () {},
            child: Container(
                height: constraints.maxHeight * 0.9,
                width: constraints.maxHeight * 0.9,
                // padding: EdgeInsets.all(16),
                child: 
                         GlitchWriter(
                              active: widget.active,
                              iconData: widget.iconData,
                              initText: widget.initText,
                              lString: makeList(
                                widget.text,
                              ))
                          // child: Text(
                          //   snapshot.data ?? UniqueKey().toString(),
                          //   style: TextStyle(),
                          ),
                    ),
                  
              
      );
    });
    }else{
    return Text(" ");
  }
  }
}

class TypeWriter extends StatefulWidget {
  TypeWriter({Key key}) : super(key: key);

  @override
  _TypeWriterState createState() => _TypeWriterState();
}

class _TypeWriterState extends State<TypeWriter> with TickerProviderStateMixin {
  Animation<int> _characterCount;

  int _stringIndex;
  static const List<String> _kStrings = const <String>[
    "panter.",
    "panter.pant",
    '[312]555-0690',
  ];
  String get _currentString => _kStrings[_stringIndex % _kStrings.length];
  @override
  void initState() {
    _start(); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle textStyle = TextStyle(
      fontSize: 2000,
      fontWeight: FontWeight.w500,
    );

    return Container(
      child: _characterCount == null
          ? null
          : new AnimatedBuilder(
              animation: _characterCount,
              builder: (BuildContext context, Widget child) {
                String text =
                    _currentString.substring(0, _characterCount.value);
                return new Text(text, style: textStyle);
              },
            ),
    );
  }

  _start() async {
    Timer(Duration(milliseconds: 400), () async {
      AnimationController controller = new AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );
      setState(() {
        _stringIndex = _stringIndex == null ? 0 : _stringIndex + 1;
        _characterCount = new StepTween(begin: 0, end: _currentString.length)
            .animate(
                new CurvedAnimation(parent: controller, curve: Curves.ease));
      });
      await controller.forward();
      controller.dispose();
    });
  }
}

class GlitchWriter extends StatefulWidget {
  final List<String> lString;
  final bool active;
  final String initText;
  final IconData iconData;
  GlitchWriter({Key key, @required this.lString, this.active, this.initText, this.iconData})
      : super(key: key);

  @override
  _GlitchWriterState createState() => _GlitchWriterState();
}

class _GlitchWriterState extends State<GlitchWriter>
    with SingleTickerProviderStateMixin {
  Animation<int> animation;
  AnimationController controller;
  List<String> listStrings = [];

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    if (animation != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.initText,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        )),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                              child: Icon(
                                animation.isCompleted?
                                widget.iconData :Icons.error_sharp,
                                color:  !animation.isCompleted?Colors.black12:
                                     widget.active
                                        ? Colors.greenAccent[400]
                                        : Colors.red[50],
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: FittedBox(
                            fit: BoxFit.contain,child:
            AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: animation.isCompleted
                    ? TextStyle(
                        color: widget.active ? Colors.black87 : Colors.black26,
                        fontWeight: FontWeight.w300,

                        fontStyle:
                            widget.active ? FontStyle.normal : FontStyle.italic)
                    : TextStyle(fontWeight: FontWeight.w500, color: colorsGrey),
                child: Text(
                  widget.lString[animation.value.round()],
                )),)))
          ],
        ),
      ); //style: animation.isCompleted? TextStyle(fontWeight: FontWeight.w500,color: Colors.black):TextStyle(fontWeight: FontWeight.w500,color: colorsGrey),);
    } else {
      return LinearProgressIndicator(backgroundColor: Colors.transparent,valueColor:new AlwaysStoppedAnimation<Color>(Colors.orange[50]),);
    }
  }

  _start() {
    Timer(Duration(milliseconds: 1400), () {
      controller = AnimationController(
          duration: const Duration(seconds: 2), vsync: this);
      animation = StepTween(begin: 0, end: widget.lString.length - 1)
          .animate(controller)
            ..addListener(() {
              setState(() {
                // The state that has changed here is the animation object’s value.
              });
            });
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

List<String> makeList(String finalString) {
  List<String> l = [];
  var rng = new Random();
 
  // l.add("...");
  for (var i = 0; i < 2; i++) {
    // l.add(UniqueKey().toString());
    l.add(".");
    l.add("..");
    l.add("...");
    l.add("....");
    l.add(".....");

    l.add(".");
    l.add("..");
    l.add("...");
  }

   for (var i = 0; i < 5; i++) {
    l.add(UniqueKey().toString());
  }

  l.add(finalString ?? "pending_release..");

  return l;
}


  