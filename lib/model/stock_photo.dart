import 'dart:convert';

import 'package:http/http.dart' as http;

class StockPhoto {
  String photo;
  String desc;

  StockPhoto({this.photo, this.desc});

  factory StockPhoto.createPhoto(Map<String, dynamic> object) {
    return StockPhoto(photo: object['full'], desc: object['urls']['full']);
  }

  static Future<List<StockPhoto>> getPhoto() async {
    String urlAPI =
        "https://api.unsplash.com/search/photos?client_id=G_7wE58YuzblZvlHfEaO9i6abUP3c0n7BRCoSIiQ9mM&query=apps&per_page=500";

    var apiResult = await http.get(urlAPI);
    var jsonObject = jsonDecode(apiResult.body);

    List<dynamic> listData = (jsonObject as Map<String, dynamic>)['results'];

    List<StockPhoto> photo = [];
    for (var i = 0; i < listData.length; i++) 
      photo.add(StockPhoto.createPhoto(listData[i]));
      // print('${listData[i]} \n\n\n');
    

    // print(listData);
    return photo;
  }
}
