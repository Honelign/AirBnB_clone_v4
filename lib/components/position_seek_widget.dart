import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration? currentPosition;
  final Duration? duration;
  final Function(Duration)? seekTo;

  PositionSeekWidget({
    @required this.currentPosition,
    @required this.duration,
    @required this.seekTo,
  });

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  bool listenOnlyUserInteraction = false;
  double get percent => widget.duration!.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration!.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition!;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInteraction) {
      _visibleValue = widget.currentPosition!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        SizedBox(
          height: 15,
          child: Slider(
            activeColor: kSecondaryColor,
            inactiveColor: kSecondaryColor.withOpacity(0.5),

            min:0,
            max: widget.duration!.inMilliseconds.toDouble(),
            value: percent * widget.duration!.inMilliseconds.toDouble(),
            onChangeEnd: (newValue) {
              setState(() {
                listenOnlyUserInteraction = false;
                widget.seekTo!(_visibleValue);
              });
            },
            onChangeStart: (_) {
              setState(() {
                listenOnlyUserInteraction = true;
              });
            },
            onChanged: (newValue) {
              setState(() {
                final to = Duration(milliseconds: newValue.floor());
                _visibleValue = to;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Text(durationToString(widget.currentPosition!),style: const TextStyle(color:kGrey),),
              Text(durationToString(widget.duration!,),style: const TextStyle(color:kGrey)),
            ],
          ),
        ),
      ],
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes =
  twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  String twoDigitSeconds =
  twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
