import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classUser.dart';

class Songs extends ChangeNotifier {
  String id;
  String title;
  String artist;
  String image;
  String song;

  Songs({
    this.id = "",
    this.title = "",
    this.artist = "",
    this.image = "",
    this.song = "",
  });

  Songs.fromSnapshot(snapshot)
      : id = snapshot.id,
        title = snapshot['songTitle'],
        artist = snapshot['artistName'],
        image = snapshot['imageUrl'],
        song = snapshot['songUrl'];

  factory Songs.fromMap(Map<String, dynamic> map) {
    return Songs(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      image: map['image'],
      song: map['song'],
    );
  }
}

// List<Songs> songArr = [];

// List<Songs> songArrs = [
//   Songs(
//     id: "1",
//     title: "Flaming Hot Cheetos",
//     artist: "Clairo",
//     image: "assets/playlist1/playlist1_gambar1.jpg",
//     song:
//         "https://firebasestorage.googleapis.com/v0/b/stavax-new.appspot.com/o/Song%2Fy2mate.com%20-%20We%20Belong%20Together.mp3?alt=media&token=d84e3af6-c34d-4f82-b579-c247e899f671",
//   ),
//   Songs(
//       id: "2",
//       title: "Like I Need You",
//       artist: "Keshi",
//       image: "assets/playlist1/playlist1_gambar2.jpg",
//       song: "assets/song/Like_I_Need_You.mp3"),
//   Songs(
//     id: "3",
//     title: "505",
//     artist: "Arctic Monkeys",
//     image: "assets/playlist1/playlist1_gambar3.jpg",
//     song: "assets/song/505.mp3",
//   ),
//   Songs(
//       id: "4",
//       title: "Runaway",
//       artist: "Aurora",
//       image: "assets/playlist2/playlist2_gambar1.jpg",
//       song: "assets/song/Runaway.mp3"),
//   Songs(
//       id: "5",
//       title: "Location Unknown",
//       artist: "HONNE",
//       image: "assets/playlist2/playlist2_gambar2.jpg",
//       song: "assets/song/Location_Unknown.mp3"),
//   Songs(
//       id: "6",
//       title: "Listerine",
//       artist: "Dayglow",
//       image: "assets/playlist2/playlist2_gambar3.jpg",
//       song: "assets/song/Listerine.mp3"),
//   Songs(
//       id: "7",
//       title: "Duvet",
//       artist: "Boa",
//       image: "assets/playlist3/playlist3_gambar1.jpg",
//       song: "assets/song/Duvet.mp3"),
//   Songs(
//       id: "8",
//       title: "Shut Up My Mom's calling",
//       artist: "Hotel Ugly",
//       image: "assets/playlist3/playlist3_gambar2.jpg",
//       song: "assets/song/Shut_Up_My_Mom_s_Calling.mp3"),
//   Songs(
//       id: "9",
//       title: "Moonlight",
//       artist: "Kali Uchis",
//       image: "assets/playlist3/playlist3_gambar3.jpg",
//       song: "assets/song/Moonlight.mp3"),
// ];
