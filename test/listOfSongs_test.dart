import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stavax_new/firebaseFetch/songFetch.dart';
import 'dart:io';
import 'package:async/async.dart';

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockListOfSongs extends Mock implements ListOfSongs {}

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

    test('uploadSong2 adds a song to the songArray if conditions are met', () async {
    // Arrange
    final String id = '1';
    final String title = 'Song Title';
    final String artist = 'Artist Name';
    final String image = 'image.jpg';
    final String selectedImageFileName = 'selected_image.jpg';
    final String song = 'song.mp3';

    final ListOfSongs listOfSongs = ListOfSongs(); // Create an instance of ListOfSongs

    // Act
    listOfSongs.uploadSong2(
      id: id,
      title: title,
      artist: artist,
      image: image,
      selectedImageFileName: selectedImageFileName,
      song: song,
    );

    // Assert
    expect(listOfSongs.songArray.length, 1); // Expect the songArray to have one element after the upload
    expect(listOfSongs.songArray[0].id, id);
    expect(listOfSongs.songArray[0].title, title);
    expect(listOfSongs.songArray[0].artist, artist);
    expect(listOfSongs.songArray[0].image, isNotNull);
    expect(listOfSongs.songArray[0].song, song);
  });

    
  });
}