import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:provider/provider.dart';
import 'package:stavax_new/fetchDatabase/fetchSong.dart';
import 'package:stavax_new/firebaseFetch/artistSongFetch.dart';
import 'package:stavax_new/firebaseFetch/insidePlaylistFetch.dart';
import 'package:stavax_new/firebaseFetch/playlistFetch.dart';
import 'package:stavax_new/firebaseFetch/songFetch.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/artist.dart';
import 'package:stavax_new/screen/profile.dart';
import 'package:stavax_new/screen/uploadSong.dart';
import '../provider/classSong.dart';
import '../screen/musicplayer.dart';
import '../screen/playlistScreen.dart';
import '../screen/search.dart';
import '../widgets/playlist_home.dart';
import '../constants/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final playlistvar_ = PlaylistHome.playlist_home();

  String userName = " ";
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getUser();
    _initializeSongs();
  }

  void _initializeSongs() async {
    try {
      print("ini home");
      context.read<ListOfSongs>().uploadSonglistDariFetch();
      context.read<UsersProvider>().uploadSongArtistlistDariFetch();
      context.read<UsersProvider>().tambahPlaylistDariFetch();
    } catch (e) {
      print("Error fetching songs: $e");
    }
  }

  void getUser() {
    final docRef =
        db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.snapshots().listen(
      (event) {
        final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";

        setState(() {
          userName = event['userName'];
        });
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAppBar(),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: const Text(
                          "Your Playlist",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _buildPlayList(),
                      Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => (playlistScreen()),
                                ),
                              );
                            },
                            child: Container(
                                width: 123,
                                height: 26,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF76BCFF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Center(
                                  child: Text(
                                    'View Playlist',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: const Text(
                          "Recently Played",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 29, horizontal: 12),
                          width: double.infinity,
                          height: 317,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              color: Color(0xff0b385f)),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: context
                                      .watch<ListOfSongs>()
                                      .songArray
                                      .length,
                                  itemBuilder: (context, index) {
                                    if (index <
                                        context
                                            .watch<ListOfSongs>()
                                            .songArray
                                            .length) {
                                      return RecentlyPlayedHome(
                                          inirecent: context
                                              .watch<ListOfSongs>()
                                              .songArray[index],
                                          currIdx: index);
                                    }
                                  },
                                ),

                                // ListView.builder(
                                //   itemCount: songArray.length,
                                //   itemBuilder: (context, index) {
                                //     if (index < songArray.length) {
                                //       return RecentlyPlayedHome(
                                //         inirecent: songArray[index],
                                //         currIdx: index,
                                //       );
                                //     }
                                //   },
                                // ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25,
      ),
      decoration: BoxDecoration(color: color1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            // "Hello, ${userName}",
            "hello, ${userName}",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const search_song()),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => profile()),
                      );
                    },
                    icon: Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                    ))
              ],
            ),
          )

          // IconButton(
          //   Icons.search,
          //   onPressed: () {},
          //   color: Colors.white,
          // ),
        ],
      ),
    );
  }

  Widget _buildPlayList() {
    return Container(
      padding: EdgeInsets.all(8),
      width: 300,
      height: 226,
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: context.watch<UsersProvider>().playListArr.isEmpty
          ? Center(
              child: Text(
                "Playlist is empty, please make one",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: context.watch<UsersProvider>().playListArr.length,
              itemBuilder: (context, index) {
                return playlist_home(
                  iniplaylist:
                      context.watch<UsersProvider>().playListArr[index],
                  listPlaylist: context.watch<UsersProvider>(),
                  currIdx: index,
                );
              },
            ),
    );
  }
}

class RecentlyPlayedHome extends StatefulWidget {
  final Songs inirecent;
  final int currIdx;

  const RecentlyPlayedHome({
    Key? key,
    required this.inirecent,
    required this.currIdx,
  }) : super(key: key);

  @override
  State<RecentlyPlayedHome> createState() => _RecentlyPlayedHomeState();
}

class _RecentlyPlayedHomeState extends State<RecentlyPlayedHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AudioPlayerScreen(
                  listSong: context.watch<ListOfSongs>().songArray,
                  song: context
                      .watch<ListOfSongs>()
                      .songArray[widget.currIdx], // Use widget.currIdx here
                  CurrIdx: widget.currIdx,
                );
              }),
            );

            // displayPersistentBottomSheet();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            width: double.infinity,
            height: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff3373b0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: widget.inirecent.image != null
                      ? File(widget.inirecent.image)
                              .existsSync() // Check if it's a local file
                          ? Image.file(
                              File(widget.inirecent.image),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            )
                          : widget.inirecent.image.startsWith(
                                  'assets/') // Check if it's an asset
                              ? Image.asset(
                                  widget.inirecent.image,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.inirecent.image,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                      : SizedBox.shrink(),
                ),

                // Image.asset(
                //   widget.inirecent.image,
                //   height: 56,
                //   width: 56,
                // ),
                SizedBox(
                  width: 11,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.inirecent.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.inirecent.artist,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
  // void displayPersistentBottomSheet() {
  //   Scaffold.of(context).showBottomSheet<void>((BuildContext context) {
  //     return PersistentBottomSheetContent(
  //         listSong: songArr,
  //         song: songArr[widget.currIdx],
  //         CurrIdx: widget.currIdx);
  //   });
  // }


// class PositionData {
//   const PositionData(
//     this.position,
//     this.bufferedPosition,
//     this.duration,
//   );

//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;
// }

// class PersistentBottomSheetContent extends StatefulWidget {
//   final List<Songs> listSong;
//   final Songs song;
//   final int CurrIdx;

//   const PersistentBottomSheetContent({
//     Key? key,
//     required this.listSong,
//     required this.song,
//     required this.CurrIdx,
//   }) : super(key: key);
//   @override
//   _PersistentBottomSheetContentState createState() =>
//       _PersistentBottomSheetContentState();
// }

// class _PersistentBottomSheetContentState
//     extends State<PersistentBottomSheetContent> {
//   late AudioPlayer _audioPlayer;

//   Stream<PositionData> get _positionDataStream =>
//       rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         _audioPlayer.positionStream,
//         _audioPlayer.bufferedPositionStream,
//         _audioPlayer.durationStream,
//         (position, bufferedPosition, duration) => PositionData(
//           position,
//           bufferedPosition,
//           duration ?? Duration.zero,
//         ),
//       );

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     List<AudioSource> audioQuery = [];
//     for (int i = 0; i < widget.listSong.length; i++) {
//       audioQuery.add(AudioSource.uri(
//         Uri.parse('asset:///' + widget.listSong[i].song),
//         tag: MediaItem(
//           id: widget.listSong[i].id.toString(), // Use toString() for id
//           title: widget.listSong[i].title,
//           artist: widget.listSong[i].artist,
//           artUri: Uri.parse(
//             widget.listSong[i].image,
//           ),
//         ),
//       ));
//     }

//     _init(audioQuery);
//   }

//   Future<void> _init(List<AudioSource> audioQuery) async {
//     await _audioPlayer.setLoopMode(LoopMode.all);
//     await _audioPlayer.setAudioSource(
//       ConcatenatingAudioSource(
//         children: audioQuery,
//       ),
//       initialIndex: widget.CurrIdx,
//       preload: true,
//     );

//     // Mulai pemutaran lagu setelah mengatur audio source
//     _audioPlayer.play();

//     // Tambahkan listener untuk mengelola pemutaran lagu
//     _audioPlayer.playerStateStream.listen((playerState) {
//       if (playerState.processingState == ProcessingState.completed) {
//         // Lagu selesai, mungkin Anda ingin menangani ini di sini
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       width: double.infinity,
//       height: 80,
//       decoration: BoxDecoration(
//         color: Color(0xff004e96),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           StreamBuilder<SequenceState?>(
//             stream: _audioPlayer.sequenceStateStream,
//             builder: (context, snapshot) {
//               final state = snapshot.data;
//               if (state?.sequence.isEmpty ?? true) {
//                 return const SizedBox();
//               }
//               final inimetadata = state!.currentSource!.tag as MediaItem;
//               return MediaMetadata(
//                   imageUrl: inimetadata.artUri.toString(),
//                   title: inimetadata.title,
//                   artist: inimetadata.artist ?? ' ');
//             },
//           ),
//           ControlsMiniPlayer(audioPlayer: _audioPlayer),
//         ],
//       ),
//     );
//   }
// }

// class MediaMetadata extends StatelessWidget {
//   const MediaMetadata({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.artist,
//   });

//   final String imageUrl;
//   final String title;
//   final String artist;

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       DecoratedBox(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Container(
//           alignment: Alignment.topCenter,
//           child: imageUrl != null
//               ? File(imageUrl).existsSync() // Check if it's a local file
//                   ? Image.file(
//                       File(imageUrl),
//                       width: 56,
//                       height: 56,
//                     )
//                   : imageUrl.startsWith('assets/') // Check if it's an asset
//                       ? Image.asset(
//                           imageUrl,
//                           width: 56,
//                           height: 56,
//                         )
//                       : Image.network(
//                           imageUrl,
//                           width: 56,
//                           height: 56,
//                         )
//               : SizedBox.shrink(),
//         ),
//         // ClipRRect(
//         //   borderRadius: BorderRadius.circular(10),
//         //   child: Image.asset(
//         //     imageUrl,
//         //   ),
//         // ),
//       ),
//       const SizedBox(
//         width: 8,
//       ),
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             artist,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 9,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     ]);
//   }
// }

// class ControlsMiniPlayer extends StatelessWidget {
//   const ControlsMiniPlayer({
//     Key? key,
//     required this.audioPlayer,
//   }) : super(key: key);

//   final AudioPlayer audioPlayer;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         StreamBuilder<PlayerState>(
//           stream: audioPlayer.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;

//             if (!(playing ?? false)) {
//               return IconButton(
//                 onPressed: audioPlayer.play,
//                 iconSize: 30,
//                 color: Colors.white,
//                 icon: const Icon(Icons.play_arrow_rounded),
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 onPressed: () {
//                   audioPlayer.pause();
//                   Navigator.of(context).pop();
//                 },
//                 iconSize: 30,
//                 color: Colors.white,
//                 icon: const Icon(Icons.pause_rounded),
//               );
//             }

//             return const Icon(
//               Icons.play_arrow_rounded,
//               size: 30,
//               color: Colors.white,
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
