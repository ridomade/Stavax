import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/colors.dart';
import '../provider/classSong.dart';
import 'package:provider/provider.dart';

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class AudioPlayerScreen extends StatefulWidget {
  final List<Songs> listSong;
  final Songs song;
  final int CurrIdx;

  const AudioPlayerScreen({
    Key? key,
    required this.listSong,
    required this.song,
    required this.CurrIdx,
  }) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    List<AudioSource> audioQuery = [];
    for (int i = 0; i < widget.listSong.length; i++) {
      audioQuery.add(AudioSource.uri(
        Uri.parse(widget.listSong[i].song),
        tag: MediaItem(
          id: widget.listSong[i].id.toString(), // Use toString() for id
          title: widget.listSong[i].title,
          artist: widget.listSong[i].artist,
          artUri: Uri.parse(
            widget.listSong[i].image,
          ),
        ),
      ));
    }

    _init(audioQuery);
  }

  Future<void> _init(List<AudioSource> audioQuery) async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    try {
      if (_audioPlayer != null) {
        await _audioPlayer.setAudioSource(
          ConcatenatingAudioSource(
            children: audioQuery,
          ),
          initialIndex: widget.CurrIdx,
          preload: true,
        );
        // Audio source set successfully
        print("Audio source set successfully");
      } else {
        // Handle the case where _audioPlayer is null
        print("_audioPlayer is null. Cannot set audio source.");
      }
    } catch (e) {
      // Handle other errors that might occur during audio source setting
      print("Error setting audio source: $e");
    }

    // Mulai pemutaran lagu setelah mengatur audio source
    _audioPlayer.play();

    // Tambahkan listener untuk mengelola pemutaran lagu
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // Lagu selesai, mungkin Anda ingin menangani ini di sini
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.more_horiz),
        //   ),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 4,
            ),
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final inimetadata = state!.currentSource!.tag as MediaItem;
                return MediaMetadata(
                    imageUrl: inimetadata.artUri.toString(),
                    title: inimetadata.title,
                    artist: inimetadata.artist ?? ' ');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 4,
                  baseBarColor: Colors.grey[600],
                  bufferedBarColor: Colors.grey,
                  thumbColor: Color(0xff0b385f),
                  progressBarColor: Color(0xff3373b0),
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: (Duration position) {
                    _audioPlayer.seek(position);
                  },
                );
              },
            ),
            Controls(
              audioPlayer: _audioPlayer,
            ),
          ],
        ),
      ),
    );
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          child: imageUrl != null
              ? File(imageUrl).existsSync() // Check if it's a local file
                  ? Image.file(
                      File(imageUrl),
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : imageUrl.startsWith('assets/') // Check if it's an asset
                      ? Image.asset(
                          imageUrl,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          imageUrl,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
              : SizedBox.shrink(),
        ),

        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: Image.asset(
        //     imageUrl,
        //     height: 300,
        //     width: 300,
        //   ),
        // ),
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        artist,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<LoopMode>(
          stream: audioPlayer.loopModeStream,
          builder: (context, snapshot) {
            return _repeatButton(context, snapshot.data ?? LoopMode.all);
          },
        ),
        InkWell(
          onTap: () {
            audioPlayer.seekToPrevious();
          },
          child: Container(
            child: Icon(
              Icons.skip_previous,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final PlayerState = snapshot.data;
            final processingState = PlayerState?.processingState;
            final playing = PlayerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
              );
            }

            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        InkWell(
          onTap: () {
            audioPlayer.seekToNext();
          },
          child: Container(
            child: Icon(
              Icons.skip_next,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        StreamBuilder<bool>(
          stream: audioPlayer.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            return _shuffleButton(context, snapshot.data ?? false);
          },
        ),
      ],
    );
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? Icon(Icons.shuffle, color: color3)
          : Icon(
              Icons.shuffle,
              color: Colors.white,
            ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await audioPlayer.shuffle();
        }
        await audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      Icon(Icons.repeat, color: Colors.white),
      Icon(Icons.repeat_one, color: color3),
    ];
    const cycleModes = [
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}
