import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smartfarm/config/api.dart';
import 'package:smartfarm/event/event_pref.dart';
import 'package:smartfarm/model/land.dart';
import 'package:smartfarm/model/user.dart';
import 'package:smartfarm/model/device.dart';
import 'package:smartfarm/pages/admin/dashboard_admin.dart';
import 'package:smartfarm/pages/farmer/dashboard_farmer.dart';
import 'package:smartfarm/widget/info.dart';

class EventDB {
  static Future<User?> login(String email, String pass) async {
    User? user;

    try {
      var response = await http.post(Uri.parse(Api.login), body: {
        'email': email,
        'password' : pass,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          user = User.fromJson(responseBody['user']);
          EventPref.saveUser(user);
          Info.snackbar('Login Berhasil');
          Future.delayed(Duration(milliseconds: 1700), () {
            Get.off(
              user!.role == 'admin'?
                  DashboardAdmin():
                  DashboardFarmer()
            );
          });
        } else {
          Info.snackbar('Login Gagal');
        }
      } else {
        Info.snackbar('Request Login Gagal');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<List<User>> getUser() async {
    List<User> listUser = [];

    try {
      var response = await http.post(Uri.parse(Api.list_user));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var users = responseBody['user'];
          users.forEach((user) {
            listUser.add(User.fromJson(user));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listUser;
  }

  static Future<List<Device>> getDevice() async {
    List<Device> listDevice = [];

    try {
      var response = await http.post(Uri.parse(Api.list_device));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var devices = responseBody['user'];
          devices.forEach((device) {
            listDevice.add(Device.fromJson(device));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDevice;
  }

  static Future<List<Land>> getLand() async {
    List<Land> listLand = [];

    try {
      var response = await http.post(Uri.parse(Api.list_land));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var lands = responseBody['user'];
          lands.forEach((land) {
            listLand.add(Land.fromJson(land));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listLand;
  }


}