import 'package:http/http.dart' show Client;
import 'package:demo_app/model/opinion_request.dart';
import 'package:demo_app/services/baseService.dart';

import '../constants.dart';

class ApiService {
   static Future regiser(body, context) async {
     return BaseApiService.save('/addUser', body, context);
   }

  static Future userProfile(body, context) async {
    return BaseApiService.save('/GetUserProfile', body, context);
  }

  static Future changePassword(body, context) async {
    return BaseApiService.save('/changePassword', body, context);
  }

  static Future removeUser(body, context) async {
    return BaseApiService.save('/removeUser', body, context);
  }

  static Future forgotPassword(body, context) async {
    return BaseApiService.save('/forgotPassword', body, context);
  }

  static Future addPushNotificationToken(body, context) async {
    return BaseApiService.save('/addPushNotificationToken', body, context);
  }

  static Future getUserFriends(body, context) async {
    return BaseApiService.save('/getUserFriends', body, context);
  }

  static Future cancelFriendRequest(body, context) async {
    return BaseApiService.save('/cancelFriendRequest', body, context);
  }

  static Future addFriendRequest(body, context) async {
    return BaseApiService.save('/addFriendRequest', body, context);
  }

  static Future rejectFriendRequest(body, context) async {
    return BaseApiService.save('/rejectFriendRequest', body, context);
  }

  static Future addFriend(body, context) async {
    return BaseApiService.save('/addFriend', body, context);
  }

  static Future removeFriend(body, context) async {
    return BaseApiService.save('/removeFriend', body, context);
  }

  static Future addEmail(body, context) async {
    return BaseApiService.save('/addEmail', body, context);
  }

  // static Future updateUser(body, context) async {
  //   return BaseApiService.save('/updateUser', body, context);
  // }

  static Future getUsers(body, context) async {
    return BaseApiService.save('/getUsers', body, context);
  }

  static Future updateUserProfilePhoto(body, context) async {
    return BaseApiService.save('/UpdateUserProfilePhoto', body, context);
  }

  static Future updateUserName(body, context) async {
    return BaseApiService.save('/UpdateUserName', body, context);
  }

  static Future updateUserPhone(body, context) async {
    return BaseApiService.save('/UpdateUserPhone', body, context);
  }

  static Future addPost(body, context) async {
    return BaseApiService.get('/AddOpinionRequest', body, context);
  }

  static Future addImageToPost(body, context) async {
    return BaseApiService.get('/AddOpinionRequest', body, context);
  }

  static Future addLike(body, context) async {
    return BaseApiService.get('/AddOpinion', body, context);
  }

  static Future getResponseForAllPostsOfUser(body, context) async {
    return BaseApiService.save('/GetResponseForAllRequestsOfUser', body, context);
  }
  static Future getRecievedOpinionRequests(body, context) async {
    return BaseApiService.get('/GetRecievedOpinionRequests',body, context);
  }
  static Future getResponseForAllRequeustOfUser(body, context) async {
    return BaseApiService.save('/GetResponseForAllRequestsOfUser',body, context);
  }

  static Future removepost(body, context) async {
    return BaseApiService.save('/removepost', body, context);
  }

}

