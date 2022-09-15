import 'package:flutter/material.dart';

import '../constants.dart';
import 'package:audio_wave/audio_wave.dart';

class KinPausedAudioWave extends StatefulWidget {
  const KinPausedAudioWave({Key? key}) : super(key: key);

  @override
  State<KinPausedAudioWave> createState() => _KinPausedAudioWaveState();
}

class _KinPausedAudioWaveState extends State<KinPausedAudioWave> {
  @override
  Widget build(BuildContext context) {
    return AudioWave(
      animation: false,
      height: 20,
      width: 15,
      spacing: 1,
      alignment: 'bottom',
      beatRate: const Duration(milliseconds: 100),
      bars: [
        AudioWaveBar(heightFactor: 0.75, color: kSecondaryColor),
        AudioWaveBar(heightFactor: 0.55, color: kSecondaryColor),
        AudioWaveBar(heightFactor: 0.75, color: kSecondaryColor),
      ],
    );
  }
}

class KinPlayingAudioWave extends StatefulWidget {
  const KinPlayingAudioWave({Key? key}) : super(key: key);

  @override
  State<KinPlayingAudioWave> createState() => _KinPlayingAudioWaveState();
}

class _KinPlayingAudioWaveState extends State<KinPlayingAudioWave> {
  @override
  Widget build(BuildContext context) {
    return AudioWave(
      animation: true,
      height: 20,
      width: 13,
      spacing: 1,
      alignment: 'bottom',
      beatRate: const Duration(milliseconds: 200),
      bars: [
        AudioWaveBar(heightFactor: 0.75, color: kSecondaryColor),
        AudioWaveBar(heightFactor: 0.55, color: kSecondaryColor),
        AudioWaveBar(heightFactor: 0.75, color: kSecondaryColor),
      ],
    );
  }
}
