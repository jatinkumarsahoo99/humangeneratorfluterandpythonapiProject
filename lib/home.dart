import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:humagenerator1/drawingarea.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui' as ui;
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DrawingArea> points = [];
  Widget imageOutput;



  void saveToImage(List<DrawingArea> points) async{
    final recorder = ui.PictureRecorder();

    final canvas = Canvas(recorder,Rect.fromPoints(Offset(0.0,0.0), Offset(200,200)));

    Paint paint = Paint()..color = Colors.white..strokeCap = StrokeCap.round..strokeWidth = 2.0;

    final paint2 = Paint()..style = PaintingStyle.fill..color = Colors.black;

    canvas.drawRect(Rect.fromLTWH(0, 0, 256, 256), paint2);

    for(int i=0;i<points.length-1;i++){
      if(points[i] != null && points[i+1] != null){
        canvas.drawLine(points[i].point, points[i+1].point, paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);

    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    final listBytes = Uint8List.view(pngBytes.buffer);

    // File file  = await WriteBytes(listBytes);

    String  base64 =  base64Encode(listBytes);
    fetchResponse(base64);




  }

  void fetchResponse(var base64Image) async{
    var data = {
      "Image":base64Image
    };

    print('Starting request');
    var url = Uri.parse("http://192.168.0.162:5000/predict");

    Map<String,String> headers = {
      'Content-type':'application/json',
      'Accept':'application/json',
      'Connection':'keep-Alive',
    };
    var body = json.encode(data);

    try{
     var response = await http.post(url,body: body,headers: headers);

     final  Map <String,dynamic> responseData = json.decode(response.body);

     String outputBytes = responseData['Image'];
     log("jks"+outputBytes.toString().substring(2,outputBytes.length-1));
     displayResponseImage(outputBytes.toString().substring(2,outputBytes.length-1));
    }catch(e){
      print(e);
      return null;
    }


  }

  void displayResponseImage(String bytes){
    Uint8List convertedBytes = base64Decode(bytes);

    setState(() {
      imageOutput = Container(
        width: 256,
        height: 256,
        child: Image.memory(convertedBytes,fit: BoxFit.contain,),

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(255, 64, 87, 1.0),
                  Color.fromRGBO(242, 133, 33, 1.0)
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    width: 256,
                    height: 256,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1),
                      ],
                    ),
                    child: GestureDetector(
                      onPanDown: (details){
                        this.setState(() {
                          log(points.toString());
                          points.add( DrawingArea(point: details.localPosition,
                              areaPaint: Paint()..strokeCap = StrokeCap.round..isAntiAlias =
                              true..color = Colors.white..strokeWidth = 2.0) ,);
                        });

                      },
                      onPanUpdate: (details){
                        this.setState(() {
                          log(points.toString());
                          points.add( DrawingArea(point: details.localPosition,
                              areaPaint: Paint()..strokeCap = StrokeCap.round..isAntiAlias =
                              true..color = Colors.white..strokeWidth = 2.0) ,);
                        });

                      },
                      onPanEnd: (details){
                        saveToImage(points);
                        this.setState(() {
                          log(points.toString());
                          points.add(null);


                        });

                      },
                      child: SizedBox.expand(child: ClipRRect(
                        borderRadius:BorderRadius.all(Radius.circular(20)),
                        child: CustomPaint( painter: MyCustomPainter(points: points),),
                      ),),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      IconButton(onPressed: (){
                        this.setState(() {

                          points.clear();
                        });
                      }, icon: Icon(Icons.layers_clear),color: Colors.black,)

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(child: Center(child: Container(
                      height: 256,
                      width: 256,
                      child: imageOutput))),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
