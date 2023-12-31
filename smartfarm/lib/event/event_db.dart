import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:smartfarm/config/api.dart';
import 'package:smartfarm/event/event_pref.dart';
import 'package:smartfarm/model/land.dart';
import 'package:smartfarm/model/user.dart';
import 'package:smartfarm/model/device.dart';
import 'package:smartfarm/pages/admin/dashboard_admin.dart';
import 'package:smartfarm/pages/admin/detail_land/manage_device.dart';
import 'package:smartfarm/pages/admin/manage_users.dart';
import 'package:smartfarm/pages/farmer/dashboard_farmer.dart';
import 'package:smartfarm/pages/farmer/detail_land/manage_device_farmer.dart';
import 'package:smartfarm/pages/farmer/landfarmer.dart';
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

  static Future<List<Land>> getDetailLand(String id) async {
    List<Land> listLand = [];

    try {
      var response = await http.post(Uri.parse(Api.list_detail_land), body: {
        'id': id,
      });

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

  static Future<List<Land>> getDetailLandbyUser(String id) async {
    List<Land> listLand = [];

    try {
      var response = await http.post(Uri.parse(Api.list_detail_land_by_user), body: {
        'user_id': id,
      });

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

  static Future<List<Device>> getDetailDevice(String id) async {
    List<Device> listDevice = [];

    try {
      var response = await http.post(Uri.parse(Api.list_device_detail), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var device = responseBody['user'];
          device.forEach((device) {
            listDevice.add(Device.fromJson(device));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDevice;
  }

  static Future<User?> addUser(String name, String email, String password, String role) async {

    try {
      var response = await http.post(Uri.parse(Api.add_user), body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role
      });

      if (response.statusCode == 200) {
        Info.snackbar("Data Success");
        Future.delayed(Duration(milliseconds: 1700), () {
          Get.off(
              ManageUser(),

          );
        });
      } else {
        Info.snackbar('Request Tambah Gagal');
      }

    } catch (e) {
      print(e);
    }
  }

  static Future<List<User>> editUser(String id, String name, String email, String password, String role) async {
    List<User> listUser = [];

    if (password != '') {
      try {
        var response = await http.post(Uri.parse(Api.edit_user), body: {
          'id': id,
          'name': name,
          'email': email,
          'password': password,
          'role': role
        });

        if (response.statusCode == 200) {
          Info.snackbar("Data Success");
          Future.delayed(Duration(milliseconds: 1700), () {
            Get.off(
                ManageUser()
            );
          });
        } else {
          Info.snackbar('Request Tambah Gagal');
        }
      } catch (e) {
        print(e);
      }
    } else if (password == '') {
      try {
        var response = await http.post(Uri.parse(Api.edit_user), body: {
          'id': id,
          'name': name,
          'email': email,
          'password': password,
          'role': role
        });

        if (response.statusCode == 200) {
          Info.snackbar("Data Success");
          Future.delayed(Duration(milliseconds: 1700), () {
            Get.off(
                ManageUser()
            );
          });
        } else {
          Info.snackbar('Request Tambah Gagal');
        }
      } catch (e) {
        print(e);
      }
    }
    return listUser;
  }

  static Future<List<User>> getDetailUser(String id) async {
    List<User> listUser = [];

    try {
      var response = await http.post(Uri.parse(Api.list_detail_user), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var user = responseBody['user'];
          user.forEach((user) {
            listUser.add(User.fromJson(user));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listUser;
  }

  static Future<User?> deleteUser(String id) async {

    try {
      var response = await http.post(Uri.parse(Api.delete_user), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar("Hapus Success");
          Future.delayed(Duration(milliseconds: 500), () {
            Get.off(
                ManageUser()
            );
          });
        } else {
          Info.snackbar("Hapus Gagal atau User masih Memiliki Lahan");
        }
      } else {
        Info.snackbar('Request Hapus Gagal');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<User?> deleteDevice(String id) async {

    try {
      var response = await http.post(Uri.parse(Api.delete_device), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar("Hapus Success");
          Future.delayed(Duration(milliseconds: 500), () {
            Get.off(
                DashboardFarmer()
            );
          });
        } else {
          Info.snackbar("Hapus Gagal");
        }
      } else {
        Info.snackbar('Request Hapus Gagal');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<User?> deleteLand(String id) async {

    try {
      var response = await http.post(Uri.parse(Api.delete_land), body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar("Hapus Gagal");
        } else {
          Info.snackbar("Hapus Success");
          Future.delayed(Duration(milliseconds: 500), () {
            Get.off(
                DashboardFarmer()
            );
          });
        }
      } else {
        Info.snackbar('Request Hapus Gagal');
      }
    } catch (e) {
      print(e);
    }
  }
  static Future<Device?> addDevices(String Id, String NameDevice, String Land_Id) async {

    try {
      var response = await http.post(Uri.parse(Api.add_devices), body: {
        'id': Id,
        'name': NameDevice,
        'land_id': Land_Id,
      });

      if (response.statusCode == 200) {
        Info.snackbar("Data Success");
        Future.delayed(Duration(milliseconds: 1700), () {
          Get.off(
              ManageDeviceFarmer(id: Land_Id)
          );
        });
      } else {
        Info.snackbar('Request Tambah Gagal');
      }

    } catch (e) {
      print(e);
    }
  }
  static Future<Device?> EditDevices(String Id, String Id_Old, String NameDevice, String Land_Id) async {

    try {
      var response = await http.post(Uri.parse(Api.edit_devices), body: {
        'id': Id,
        'id_old': Id_Old,
        'name': NameDevice,
        'land_id': Land_Id,
      });

      if (response.statusCode == 200) {
        Info.snackbar("Data Success");
        Future.delayed(Duration(milliseconds: 1700), () {
          Get.off(
              ManageDeviceFarmer(id: Land_Id)
          );
        });
      } else {
        Info.snackbar('Request Tambah Gagal');
      }

    } catch (e) {
      print(e);
    }
  }

  static Future<Land?> addLahan(String name, String description, String maps, String status, String date, String id, String area) async {

    try {
      var response = await http.post(Uri.parse(Api.add_lahan), body: {
        'name': name,
        'description': description,
        'polygon': maps,
        'area': area,
        'crop_status': status,
        'crop_planted_at': date,
        'user_id': id,
      });

      if (response.statusCode == 200) {
        Info.snackbar("Data Success");
        Future.delayed(Duration(milliseconds: 1700), () {
          Get.off(
              DashboardFarmer()
          );
        });
      } else {
        Info.snackbar('Request Tambah Gagal');
      }

    } catch (e) {
      print(e);
    }
  }
  static Future<Land?> editLahan(String id, String name, String description, String maps, String status, String date, String user_id, String area) async {

    try {
      var response = await http.post(Uri.parse(Api.edit_lahan), body: {
        'id': id,
        'name': name,
        'description': description,
        'polygon': maps,
        'area': area,
        'crop_status': status,
        'crop_planted_at': date,
        'user_id': user_id,
      });

      if (response.statusCode == 200) {
        Info.snackbar("Data Success");
        Future.delayed(Duration(milliseconds: 1700), () {
          Get.off(
              DashboardFarmer()
          );
        });
      } else {
        Info.snackbar('Request Tambah Gagal');
      }

    } catch (e) {
      print(e);
    }
  }
}