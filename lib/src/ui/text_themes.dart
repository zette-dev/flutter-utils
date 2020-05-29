// import 'package:flutter/material.dart';

// class TitleText extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextAlign alignment;

//   const TitleText({Key key, @required this.text, this.centered, this.alignment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _Text(
//       text: text,
//       centered: centered,
//       alignment: alignment,
//       style: Theme.of(context).textTheme.headline6,
//     );
//   }
// }

// class ButtonText extends StatelessWidget {
//   final String text;

//   const ButtonText({Key key, @required this.text}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: Theme.of(context).textTheme.button,
//     );
//   }
// }

// class CaptionText extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextAlign alignment;

//   const CaptionText(
//       {Key key, @required this.text, this.centered, this.alignment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _Text(
//       text: text,
//       centered: centered,
//       alignment: alignment,
//       style: Theme.of(context).textTheme.caption,
//     );
//   }
// }

// class Body1Text extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextAlign alignment;

//   const Body1Text({Key key, @required this.text, this.centered, this.alignment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _Text(
//       text: text,
//       centered: centered,
//       alignment: alignment,
//       style: Theme.of(context).textTheme.bodyText1,
//     );
//   }
// }

// class Body2Text extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextAlign alignment;

//   const Body2Text({Key key, @required this.text, this.centered, this.alignment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _Text(
//       text: text,
//       centered: centered,
//       alignment: alignment,
//       style: Theme.of(context).textTheme.bodyText2,
//     );
//   }
// }

// class OverlineText extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextAlign alignment;

//   const OverlineText(
//       {Key key, @required this.text, this.centered, this.alignment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _Text(
//       text: text,
//       centered: centered,
//       alignment: alignment,
//       style: Theme.of(context).textTheme.overline,
//     );
//   }
// }

// class HeadlineText extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextAlign alignment;

//   const HeadlineText(
//       {Key key, @required this.text, this.centered, this.alignment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _Text(
//       text: text,
//       centered: centered,
//       alignment: alignment,
//       style: Theme.of(context).textTheme.headline5,
//     );
//   }
// }

// class _Text extends StatelessWidget {
//   final String text;
//   final bool centered;
//   final TextStyle style;
//   final TextAlign alignment;

//   _Text({
//     Key key,
//     @required this.text,
//     this.centered = false,
//     this.style,
//     this.alignment = TextAlign.start,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _text = Text(
//       text ?? '',
//       style: style,
//       textAlign: (centered ?? false) ? TextAlign.center : alignment,
//     );
//     if (centered != null && centered) {
//       return Center(
//         child: _text,
//       );
//     } else {
//       return _text;
//     }
//   }
// }
