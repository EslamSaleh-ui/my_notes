import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mynotes/main.dart';
import 'package:toast/toast.dart';
import 'DB.dart';

final box=GetStorage();
final language='en'.val('language'),font='Macondo-Regular'.val('font');

class first extends StatefulWidget {
  final String moral;
  final String title;
  final String note;
  final String archived;
  final int id;
  final int color;
  const first({@required this.moral,this.id,this.title,this.note,this.color,this.archived, Key key}) : super(key: key);
  @override
  State<first> createState() => _first();
}
class _first extends State<first> {
  final GlobalKey<FormState> key=GlobalKey<FormState>();
  final u=TextEditingController();
  final i=TextEditingController();
  Color f=Colors.cyanAccent;
  DB db;
  @override
  initState(){
    super.initState();
    db=DB();
    if(widget.moral=='update')
      {u.text=widget.title;
        i.text=widget.note;
        f=Color(widget.color);}
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor:f,
      appBar:AppBar(
        leading:IconButton(onPressed:(){Get.off(()=>MyHomePage());},icon:Icon(Icons.arrow_back_ios))
        ,backgroundColor:Colors.transparent ,
        elevation: 0,
        actions: [IconButton(onPressed:(){
          Get.defaultDialog(
            title: '',
          middleText:'' ,
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: FastColorPicker(
           selectedColor: Colors.cyanAccent,
            onColorSelected:(color){f=color;setState((){});}
          )));
        }, icon: Icon(Icons.palette,color:Colors.white))],
      ) ,
      body: Form(
          key: key,
        child:SingleChildScrollView(
            child: Column(
          children: [ TextFormField(
                 controller: u,
                 validator:isValidPasscode1 ,
                 autovalidateMode:AutovalidateMode.onUserInteraction ,
                 style:TextStyle(fontFamily: font.val,fontSize: 25) ,
                 decoration:InputDecoration(labelText : 'title'.tr,
                 counter:Text('${u.text.length}/35') ,
                 enabledBorder:OutlineInputBorder(borderSide:BorderSide.none )
                     ,errorBorder:OutlineInputBorder(borderSide:BorderSide.none )
                     ,focusedBorder:OutlineInputBorder(borderSide:BorderSide.none ))
               ), TextFormField(
                controller: i,
                maxLines: 15,
                maxLength: 500,
                minLines: 1,
                validator:isValidPasscode ,
            autovalidateMode:AutovalidateMode.onUserInteraction  ,
                style:TextStyle(fontFamily: font.val,fontSize: 25) ,
                decoration:InputDecoration(labelText : 'Add Note'.tr,
                    enabledBorder:OutlineInputBorder(borderSide:BorderSide.none )
                    ,errorBorder:OutlineInputBorder(borderSide:BorderSide.none )
                    ,focusedBorder:OutlineInputBorder(borderSide:BorderSide.none ))
            )
          ],
        ) )
      ) ,
      floatingActionButton:FloatingActionButton(
        tooltip:'save'.tr ,
        onPressed: () async{
          load(context);
          if(key.currentState.validate()){
          if(widget.moral=='update')
            {db.updates(Note({'id':widget.id,'title':u.text,'note':i.text,'font':font.val,'date':DateTime.now().toString(),'color':f.value,'archived':widget.archived}));
            }else
            {Note cB=Note({'title':u.text,'note':i.text,'font':font.val,'date':DateTime.now().toString(),'color':f.value,'archived':false.toString()});
          await db.insertDB(cB);}
          Toast.show('Saved'.tr,gravity:Toast.bottom,duration: Toast.lengthLong );
          Get.off(()=>MyHomePage());}
          },
        child:Icon(Icons.one_k) ,
        backgroundColor: Colors.cyan
      )
    );
  }
String isValidPasscode(String f)
{
  if(f==null || f.isEmpty)
    return '1'.tr;
  else if(f.length<100)
  return '2'.tr;
 else if(f.length>500)
   return '3'.tr;
 return null;
}
  String isValidPasscode1(String f)
  {
    if(f==null || f.isEmpty)
      return '1'.tr;
    else if(f.length<8)
      return '4'.tr;
    else if(f.length>35)
      return '5'.tr;
    return null;
  }
}

class Languages implements Translations{
  @override
  Map<String, Map<String, String>> get keys =>{
    "ar":{"load":"تحميل","home":"الصفحة الرئيسية","add":"أضافة ملحوظة جديدة","choose":"أختر نوع الخط",
           "language":"غير اللغة","mode":"تغيير الوضع" ,"archive":"الارشيف","Add Note":"دون الملاحظة",
    "1":"هذا الحقل مطلوب","2":"يجب أن يحتوى على 100 حرف عالاقل","3":"يجب أن يكون أقل من 500 حرف",
      "4":"يجب أن يحتوى على 8 حروف عالاقل","5":"يجب أن يكون أقل من 35 حرف",
      "title":"العنوان","save":"حفظ","Saved":"تم الحفظ" },
    "en":{"load":"loading","home":"Home Page","add":"Add new note","choose":"Choose Font","save":"save",
      "1":"This Field is needed","2":"Must be at least 100 characters","3":"Must not be more than 500 characters",
    "language":"Change language","mode":"Change mode","archive":"Archive","Add Note":"Add Note",
    "title":"title","4":"Must be at least 8 characters","5":"Must not be more than 35 characters",
    "Saved":"Saved" }
  };
}
load(BuildContext c){
  Get.dialog(
      Dialog(backgroundColor:Colors.black.withOpacity(0.2),
          child:Container(
              height:MediaQuery.of(c).size.height,
              width: MediaQuery.of(c).size.width,
              child:Center(child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('    '),CircularProgressIndicator(color:Colors.lightBlue),Text('   '),Text("load".tr,style: TextStyle(color: Colors.white,fontSize:20 ))],))
          )   ));
  Future.delayed(Duration(seconds: 3),(){Get.back();});
}