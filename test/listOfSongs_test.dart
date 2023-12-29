import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stavax_new/firebaseFetch/songFetch.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:stavax_new/screen/detailedPlaylist.dart';

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockSongsProvider extends Mock implements ListOfSongs {}

void main() {
  group('ListOfSongs', () {
    test('hapusLaguBener removes the song correctly', () {
      // Arrange
      ListOfSongs listOfSongs = ListOfSongs();
      Songs songToRemove = Songs(
        id: '1',
        title: 'Song Title',
        artist: 'Artist Name',
        image: 'image_url',
        song: 'song_url',
      );

      listOfSongs.songArray.add(songToRemove);

      // Act
      listOfSongs.hapusLaguBener(song: songToRemove);

      // Assert
      expect(listOfSongs.songArray, isEmpty);
    });

    test('hapusLaguBener notifies listeners after removing a song', () {
      // Arrange
      final ListOfSongs listOfSongs = ListOfSongs();
      final Songs songToRemove = Songs(
        id: '1',
        title: 'Song Title',
        artist: 'Artist Name',
        image: 'image.jpg',
        song: 'song.mp3',
      );

      // Add a song to the songArray
      listOfSongs.songArray.add(songToRemove);

      // Act
      listOfSongs.hapusLaguBener(song: songToRemove);

      // Assert
      expect(listOfSongs.songArray.length, 0);

      // Verify that notifyListeners was called
      expect(listOfSongs, emitsInOrder([isInstanceOf<ChangeNotifier>()]));
    });

    test('filterSongs filters songs correctly', () {
      // Arrange
      ListOfSongs listOfSongs = ListOfSongs();
      List<Songs> initialSongs = [
        Songs(
          id: '1',
          title: 'Song Title 1',
          artist: 'Artist Name 1',
          image: 'image_url_1',
          song: 'song_url_1',
        ),
        Songs(
          id: '2',
          title: 'Song Title 2',
          artist: 'Artist Name 2',
          image: 'image_url_2',
          song: 'song_url_2',
        ),
        Songs(
          id: '3',
          title: 'Song Title 3',
          artist: 'Artist Name 3',
          image: 'image_url_3',
          song: 'song_url_3',
        ),
      ];

      listOfSongs.songArray.addAll(initialSongs);

      // Act
      listOfSongs.filterSongs('Title 2');

      // Assert
      expect(listOfSongs.songArray.length, 1);
      expect(listOfSongs.songArray.first.title, 'Song Title 2');
    });

    test(
        'uploadSong adds a new song to songArray when all parameters are valid',
        () async {
      // Create an instance of ListOfSongs and initialize the function parameters
      final listOfSongs = ListOfSongs();
      final title = 'Sample Title';
      final artist = 'Sample Artist';
      final image = File('assets/1.png');
      final selectedImageFileName = '1.png';
      final song = 'assets/505.mp3';
      final id = '1';

      // Call the function
      listOfSongs.uploadSong(
        title: title,
        artist: artist,
        image: image,
        selectedImageFileName: selectedImageFileName,
        song: song,
        id: id,
      );

      // Verify that the song has been added to songArray
      expect(listOfSongs.songArray[-1].id, id);
      expect(listOfSongs.songArray[-1].title, title);
      expect(listOfSongs.songArray[-1].artist, artist);
      expect(listOfSongs.songArray[-1].image, contains(selectedImageFileName));
      expect(listOfSongs.songArray[-1].song, song);

      // Clean up: Delete the created image file
      final appDocDir = await getApplicationDocumentsDirectory();
      final localImage = File("${appDocDir.path}/$selectedImageFileName");
      if (await localImage.exists()) {
        await localImage.delete();
      }
    });
    test('uploadSonglistDariFetch add songs to songList', () async {
      final listOfSongs = ListOfSongs();
      List<Songs> testSongArray = [];

      List<Songs> song = await songFetch();
      for (var i = 0; i < song.length; i++) {
        testSongArray.add(Songs(
          id: song[i].id,
          title: song[i].title,
          artist: song[i].artist,
          image: song[i].image,
          song: song[i].song,
        ));
      }
      List<Songs> testSongArrayDari = [];
      listOfSongs.songArray = testSongArrayDari;
      listOfSongs.uploadSonglistDariFetch();

      expect(testSongArray.length, testSongArrayDari.length);
    });
  });
}
