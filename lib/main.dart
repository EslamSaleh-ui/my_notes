import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'DB.dart';
import 'archived.dart';
import 'first.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp( GetMaterialApp(
  theme: Get.theme,
  debugShowCheckedModeBanner: false,
  locale:Locale(language.val),
  fallbackLocale:Locale("en") ,
  translations:Languages() ,home: MyApp()));
}

class MyApp extends StatelessWidget {
   MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   SplashScreen(
        photoSize:MediaQuery.of(context).size.width/3,
        image: Image.asset('assets/Untitled-1.png'),
        backgroundColor:HexColor('#3eebe5'),
        seconds: 5,
        useLoader: false,
        navigateAfterSeconds:MyHomePage() );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({Key key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin   {
  DB s=DB();
  FancyDrawerController _controller;
   List<String> fonts1=['Anton-Regular','KaushanScript-Regular','Lobster-Regular',
   'Macondo-Regular','Staatliches-Regular'];
   List<String> fonts2=['Lalezar-Regula','Qahiri-Regular','Rakkas-Regular','ReemKufi-VariableFont_wght',
   'Tajawal-ExtraBold'];
  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {}); // Must call setState
      });// This chunk of code is important
  }
  @override
  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
       body: FancyDrawerWrapper(
        backgroundColor: Colors.cyan,
        controller: _controller,
        drawerItems:[
          ExpansionTile(
            trailing:language.val=='ar'?Icon(Icons.font_download_sharp,):null ,
                backgroundColor:Colors.cyan ,
                leading:Icon(Icons.font_download_sharp,),
                title:Text('choose'.tr, style: TextStyle(color:Colors.black,fontSize: 20),textDirection:TextDirection.ltr),
                children:Get.locale==Locale('en')?fonts1.map((e) {
                  return ListTile(
                      trailing:language.val=='ar'?Text('ABC',style: TextStyle(fontFamily:e )):null ,
                      leading:Text('ABC',style: TextStyle(fontFamily:e )) ,
                      title:Text(e,textDirection:TextDirection.ltr) ,
                      onTap:(){font.val=e;
                      Toast.show('Saved'.tr,gravity:Toast.bottom,duration: Toast.lengthLong );} );
                }).toList():fonts2.map((e) {
                  return ListTile(
                    trailing:language.val=='ar'?Text('أبجد',style: TextStyle(fontFamily:e )):null ,
                      leading:Text('أبجد',style: TextStyle(fontFamily:e )) ,
                      title:Text(e,textDirection:TextDirection.ltr) ,
                      onTap:(){font.val=e;
                      Toast.show('Saved'.tr,gravity:Toast.bottom,duration: Toast.lengthLong );} );
                }).toList(),
              ),
                ExpansionTile(
                  backgroundColor:Colors.cyan ,
                  trailing:language.val=='ar'?Icon(Icons.auto_mode):null ,
                  leading:Icon(Icons.auto_mode),
                  title:Text('mode'.tr,style: TextStyle(color:Colors.black,fontSize: 20),textDirection:TextDirection.ltr) ,
                  children: [
                    ListTile(
                        trailing:language.val=='ar'?Icon(Icons.dark_mode):null ,
                        leading:Icon(Icons.dark_mode),
                        title:Text('dark'.tr,style: TextStyle(color:Colors.black,fontSize: 20),textDirection:TextDirection.ltr) ,
                        onTap:(){setState((){Get.changeTheme(ThemeData.dark());});} ),
                    ListTile(trailing: language.val=='ar'?Icon(Icons.brightness_1,color:Colors.yellow):null,
                        leading:Icon(Icons.brightness_1,color:Colors.yellow),
                        title:Text('light'.tr,style: TextStyle(color:Colors.black,fontSize: 20),textDirection:TextDirection.ltr) ,
                        onTap:(){Get.changeTheme(ThemeData.light());setState((){});} )
                  ],
                ),
                ListTile(
                    trailing: language.val=='ar'?Icon(Icons.language):null ,
                    leading:Icon(Icons.language),
                    title:Text('language'.tr,style: TextStyle(color:Colors.black,fontSize: 20),textDirection:TextDirection.ltr) ,
                    onTap:(){
                      if(Get.locale==Locale('ar')) {
                        Get.updateLocale(Locale('en')); language.val='en'; }
                      else
                      {   Get.updateLocale(Locale('ar')); language.val='ar';}
                      } ),  ListTile(trailing:language.val=='ar'? Icon(Icons.archive):null,
                        leading:Icon(Icons.archive),
                    title:Text('archive'.tr,style: TextStyle(color:Colors.black,fontSize: 20),textDirection:TextDirection.ltr) ,
                    onTap:(){Get.to(()=>archived());  } )],
        child:  Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ), onPressed: () { _controller.toggle(); },),
            backgroundColor:Colors.cyan ,
            title: Text('home'.tr,style: TextStyle(color:Colors.white,fontSize: 20)),
          ),
          body:Builder(builder:(_){
            return  Column(children: [
            Expanded(flex: 1, child: Container(margin: EdgeInsets.all(10),
              alignment:Alignment.center,color:Colors.grey ,width: MediaQuery.of(context).size.width, child: DropdownButton(onChanged: (value) {  }, items: [DropdownMenuItem(child: Text('wow')) ])  )),
  Expanded(child: FutureBuilder(
            future: s.query(),
            builder: (context,snapshot)
            {if(!snapshot.hasData )
              return Center(child:Row(children:[Icon(Icons.hourglass_empty,color:Colors.grey),Text('no Data Found')]));
            else if(snapshot.connectionState==ConnectionState.waiting)
              return Center(child:CircularProgressIndicator(color:Colors.green));
            if(snapshot.hasError)
              return Center(child:Row(children:[Icon(Icons.error_outline,color:Colors.red),Text('Something went Error',style: TextStyle(color:Colors.red ))]));
            return MasonryGridView.builder(
                itemCount:snapshot.data.length ,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount:1 ),
                itemBuilder:(context, index) {
                  Note a = Note.fromMap(snapshot.data[index]);
                  DateTime date=DateTime.parse(a.date);
                  if (a.archived==true.toString()) return Container();
                  // return ListTile(
                  //   title: Text(a.note),
                  //   subtitle: Text(a.date),
                  //   selectedColor: Colors.red,
                  // );
                  return Container(
                      margin:EdgeInsets.all(5)  ,
                      padding:EdgeInsets.all(5) ,
                      constraints:BoxConstraints(maxHeight:double.infinity,maxWidth: double.infinity) ,
                      decoration:BoxDecoration( color:Color(a.color),borderRadius:BorderRadius.circular(15),border:Border.all(color:Colors.black ) ) ,
                      child:Column(
                          crossAxisAlignment:CrossAxisAlignment.start ,
                          children: [Text(a.title,style: TextStyle(fontWeight:FontWeight.bold,fontStyle: FontStyle.normal ,  fontSize: 25,fontFamily:a.font )),
                            Padding(padding:EdgeInsets.only(bottom:5) , child: Text(a.note,style: TextStyle(fontSize: 21,fontFamily:a.font,fontWeight:FontWeight.bold,fontStyle: FontStyle.normal  ))),
                            Text(date.year.toString()+'/'+date.month.toString()+'/'+date.day.toString(),style: TextStyle(fontSize: 15,fontFamily:a.font,fontWeight:FontWeight.bold,fontStyle: FontStyle.normal  ),),
                            Row(mainAxisAlignment:MainAxisAlignment.end ,
                                children: [IconButton(onPressed: (){
                                  s.delete(a.id);
                                  setState((){});
                                }, icon:Icon(Icons.delete,color: Colors.red,)),IconButton(onPressed: (){
                                  Get.off(()=>first(moral:'update',id:a.id,title:a.title,note:a.note,color:a.color,archived: a.archived));
                                }, icon:Icon(Icons.mode_edit,color: Colors.green,)),
                                  IconButton(onPressed:(){s.updates(Note({'id':a.id,'title':a.title,'note':a.note,'font':a.font,'date':a.date,'color':a.color,'archived':true.toString()}));
                                  setState((){});
                                  }, icon: Icon(Icons.archive_outlined))
                                ])
                          ])
                  );
                });
            },
          ),flex: 9)
          ]  );}),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.cyan,
            onPressed:(){Get.off(()=>first(moral:'create'));},
            tooltip: 'add'.tr,
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
           )));
  }
}
