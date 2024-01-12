// import 'package:flutter/material.dart';

// class MyTimer extends StatefulWidget {
//   final int chrono;
//   const MyTimer({super.key, required this.chrono});

//   @override
//   State<MyTimer> createState() => _MyTimerState();
// }

// class _MyTimerState extends State<MyTimer> with TickerProviderStateMixin {
//   late AnimationController _controller;


//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//         vsync: this,
//         duration: Duration(
//             seconds:
//                 widget.chrono) // gameData.levelClock is a user entered number elsewhere in the applciation
//         );

//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Countdown(
//               animation: StepTween(
//                 begin: widget.chrono, // THIS IS A USER ENTERED NUMBER
//                 end: 0,
//               ).animate(_controller),
//             );
            
//   }
// }

// // ignore: must_be_immutable
// class Countdown extends AnimatedWidget {
//   Countdown({ super.key, required this.animation}) : super(listenable: animation);
//   Animation<int> animation;

//   @override
//   build(BuildContext context) {
//     Duration clockTimer = Duration(seconds: animation.value);

//     String timerText =
//         '${clockTimer.inHours.remainder(24).toString()}h${clockTimer.inMinutes.remainder(60).toString()}min${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}s';

//     // print('animation.value  ${animation.value} ');
//     // print('inHours ${clockTimer.inHours.toString()}');
//     // print('inMinutes ${clockTimer.inMinutes.toString()}');
//     // print('inSeconds ${clockTimer.inSeconds.toString()}');
//     // print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

//     return Text(
//       timerText,
//       style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
//       );
//   }
// }