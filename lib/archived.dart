import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'DB.dart';

class archived extends StatefulWidget {
  const archived({Key key}) : super(key: key);
  @override
  State<archived> createState() => _archived();
}
class _archived extends State<archived> {
  DB s=DB();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
              appBar: AppBar(
                backgroundColor:Colors.cyan ,
                title: Text('archive'.tr,style: TextStyle(color:Colors.white,fontSize: 20)),
              ),
              body: FutureBuilder(
                future: s.query(),
                builder: (context,snapshot)
                {if(!snapshot.hasData )
                  return Row(children:[Icon(Icons.hourglass_empty,color:Colors.grey),Text('no Data Found')]);
                else if(snapshot.connectionState==ConnectionState.waiting)
                  return Center(child:CircularProgressIndicator(color:Colors.white));
                if(snapshot.hasError)
                  return Row(children:[Icon(Icons.error_outline,color:Colors.red),Text('Something went Error',style: TextStyle(color:Colors.red ))]);
                return MasonryGridView.builder(
                    itemCount:snapshot.data.length ,
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount:2 ),
                    itemBuilder:(context, index) {
                      Note a = Note.fromMap(snapshot.data[index]);
                      DateTime date=DateTime.parse(a.date);
                      if (a.archived==false.toString()) return Container();
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
                                }, icon:Icon(Icons.delete,color: Colors.red,)),
                                  IconButton(onPressed:(){s.updates(Note({'id':a.id,'title':a.title,'note':a.note,'font':a.font,'date':a.date,'color':a.color,'archived':false.toString()}));
                                    setState((){});
                                    }, icon: Icon(Icons.archive_outlined))
                                ])
                          ])
                      );});
                },
              )
            );
  }
}


