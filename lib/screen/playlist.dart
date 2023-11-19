import 'package:flutter/material.dart';

class YourPlaylist extends StatefulWidget {
  const YourPlaylist({super.key});

  @override
  State<YourPlaylist> createState() => _YourPlaylistState();
}

class _YourPlaylistState extends State<YourPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 50,
            ),
            Text(
              "Your Playlist",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
      // body: ,
    );
  }
}