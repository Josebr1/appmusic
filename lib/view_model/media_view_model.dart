import 'package:appmusic/model/media.dart';
import 'package:appmusic/service/media_service.dart';
import 'package:appmusic/utils/api_response.dart';
import 'package:flutter/material.dart';


class MediaViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  
  
  ApiResponse get response {
    return _apiResponse;
  }
  
  Future<void> fetchMediaData(String value) async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();

    try {
      List<Media> mediaList = await MediaService().fetchMediaList(value);
      _apiResponse = ApiResponse.completed(mediaList);
    } catch (ex) {
      _apiResponse = ApiResponse.error(ex.toString());
      print(ex);
    }

    notifyListeners();
  }
}