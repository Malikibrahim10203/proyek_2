import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartfarm/model/device.dart';
import 'package:smartfarm/event/event_db.dart';
import 'package:smartfarm/event/event_pref.dart';
import 'package:smartfarm/model/land.dart';
import 'package:smartfarm/model/user.dart';
import 'package:smartfarm/pages/admin/add/tambah_user.dart';
import 'package:smartfarm/pages/admin/detail_land/manage_device.dart';
import 'package:smartfarm/pages/admin/detail_land/overview.dart';
import 'package:smartfarm/pages/admin/landadmin.dart';
import 'package:smartfarm/pages/admin/manage_users.dart';
import 'package:smartfarm/pages/deteksi/deteksi.dart';
import 'package:smartfarm/pages/education/rawat_padi.dart';
import 'package:smartfarm/pages/login.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);



  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {

  List<Device> totalDevice = [];
  List<User> totalUser = [];
  late String userName ;

  void getDevice() async {
    totalDevice = await EventDB.getDevice();
    setState(() {});
  }

  void getUser() async {
    totalUser = await EventDB.getUser();
    userName = (await EventPref.getUser())?.name ?? "";
    setState(() {

    });
  }

  List<Land> listLand = [];
  void getLand() async {
    listLand = await EventDB.getLand();
    setState(() {});
  }


  @override
  void initState() {
    getLand();
    getDevice();
    getUser();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF1F1F1),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffFFFFFF),
          titleTextStyle: TextStyle(color: Color(0xff545454)),
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/img/profile.png", width: MediaQuery.of(context).size.width * 0.08,),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Hello, Dummy"),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Admin", style: TextStyle(fontSize: 12),),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  // Image.asset("assets/img/Logo.png", width: MediaQuery.of(context).size.width * 0.3,),
                  Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none, color: Color(0xff545454),)),
                      SizedBox(
                        width: 10,
                      ),
                      PopupMenuButton(
                        child: Image.asset("assets/img/menu.png", width: MediaQuery.of(context).size.width * 0.04),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.settings, size: 15, color: Colors.black45,),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Setting", style: TextStyle(fontSize: 12),)
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 15, color: Colors.black45,),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("LogOut", style: TextStyle(fontSize: 12),)
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if(value == 0) {
                            print("settings");
                          } else if (value == 1) {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.warning_amber),
                                      Text("LogOut", style: TextStyle(fontSize: 12),)
                                    ],
                                  ),
                                  content: Text("Apakah anda yakin ingin keluar?", style: TextStyle(fontSize: 12),),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Tidak"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        EventPref.clear();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                      },
                                      child: Text("Ya"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        body: Container(
          child: SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      color: Color(0xffFFFFFF),
                      height: MediaQuery.of(context).size.height * 0.285,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 25, top: 20, right: 25),
                            child: Row(
                              children: [
                                Icon(Icons.school_outlined, size: 20, color: Color(0xff408CFF),),
                                SizedBox(width: 10,),
                                Text("Edukasi Pertanian", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CarouselSlider(
                            items: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RawatPadi()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: AssetImage("assets/img/banner1.png"),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ),
                            ],
                            options: CarouselOptions(
                                height: MediaQuery.of(context).size.height * 0.2,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 6/9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                                viewportFraction: 0.8
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: listLand.length,
                                itemBuilder: (context, index) {
                                  Land land = listLand[index];
                                  DateTime datePlanted = DateTime.parse("${land.cropPlantedAt}");
                                  DateTime dateNow = DateTime.now();
                                  Duration diff = datePlanted.difference(dateNow);

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffF1F1F1),
                                    ),
                                    child: ListTile(
                                      title: Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Color(0xffFFFFFF),
                                              border: Border(
                                                left: BorderSide(
                                                  color: Color(0xffFF7B7B),
                                                  width: 5,
                                                ),
                                                right: BorderSide(
                                                  color: Color(0xffFF7B7B),
                                                  width: 0,
                                                ),
                                                top: BorderSide(
                                                  color: Color(0xffFF7B7B),
                                                  width: 0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Color(0xffFF7B7B),
                                                  width: 0,
                                                ),
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset("assets/img/sawah.jpg", width: 100,),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(land.name??'', style: TextStyle(color: Color(0xff747474), fontSize: 12, fontWeight: FontWeight.w600),),
                                                                Text("${diff.abs().inDays.toString()} hari", style: TextStyle(color: Color(0xff737373), fontSize: 9),)
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Kurang Air dan Kurang Pupuk",
                                                                  style: TextStyle(color: Color(0xff737373), fontSize: 9, fontWeight: FontWeight.w400),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Color(0xff408CFF),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Overview(id: land.id??'')));
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DeteksiPage()));
          },
          child: Icon(Icons.document_scanner_outlined),
          elevation: 4,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: Color(0xffCCCCCC), width: 1)),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: IconButton(
                    icon: Icon(
                      Icons.home_outlined,
                      size: 30,
                    ),
                    onPressed: () { },
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: IconButton(
                      icon: Icon(
                        Icons.manage_accounts_outlined,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageUser()));
                      },
                    ),
                  ),
                  label: 'History'
              ),
            ],
          ),
        )
    );
  }
}
