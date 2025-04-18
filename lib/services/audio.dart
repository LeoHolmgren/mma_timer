import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';

class Audio {
  late Soundpool _soundpool;
  late Map<String, Future<int>> _cache;

  static const String RING_BELL_1 = 'assets/sounds/ring_bell1.wav';
  static const String RING_BELL_2 = 'assets/sounds/ring_bell2.wav';
  static const String RING_BELL_3 = 'assets/sounds/ring_bell3.wav';

  Audio() {
    _soundpool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));

    // buffer sounds
    _cache = Map();
    _cache[RING_BELL_1] = _loadSound(RING_BELL_1);
    _cache[RING_BELL_2] = _loadSound(RING_BELL_2);
    _cache[RING_BELL_3] = _loadSound(RING_BELL_3);
  }

  Future<int> _loadSound(String assetPath) async {
    var asset = await rootBundle.load(assetPath);
    return await _soundpool.load(asset);
  }

  Future<void> _playSound(Future<int> soundId) async {
    var sound = await soundId;
    await _soundpool.play(sound);
  }

  Future<void> play(String cachedAsset) async {
    var soundId = _cache[cachedAsset];
    if (soundId != null) {
      await _playSound(soundId);
    } else {
      throw ArgumentError('Sound not found for asset: $cachedAsset');
    }
  }

  Future<void> dispose() async {
    await _soundpool.release();
    _soundpool.dispose();
  }
}
