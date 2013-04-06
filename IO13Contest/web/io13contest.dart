import 'dart:html';
import 'dart:json';
import 'dart:async';
import 'package:js/js.dart' as js;
import 'package:google_maps/js_wrap.dart' as jsw;
import 'package:google_maps/google_maps.dart';

void main() {
  EventsModel evm;
  HttpRequest.getString("events.json").then((e)=> evm = new EventsModel(e));
}

class EventsModel{
  String temp;
  List eventsData,daylist;
  Map eventsByDay;
  
  InputElement slider,playstop;
  Timer repeticion;
  bool playing = false;
  
  EventsModel(this.temp){
    slider = query("#slider");
    playstop = query("#playstop");
    eventsData = parse(temp);
    eventsByDay = new Map();
    daylist = new List();
    eventsData.forEach((e)=>processEvent(e));
        
    printEventByDay();
    slider.max = "${daylist.length-1}";
    circles = new List();
    showMap();
    
    playstop.onClick.listen((e)=>timerStarter());
  }
  
  void timerStarter(){
    if (playing){
      playstop.value="Play";
      repeticion.cancel();
      playing = false;
    }else{
      playstop.value="Stop";
      repeticion = new Timer.periodic(new Duration(milliseconds:700),timerClick);
    }
  }
  
  void timerClick(Timer t){
    playing = true;
    if (int.parse(slider.value) < daylist.length-1){
      slider.value = "${int.parse(slider.value)+1}";
      addMarker();
    }else{
      playing = false;
      repeticion.cancel();
    }
  }
  
  void processEvent(event){
    //printlocation(event);
    asingEventByDay(event);
  }
  
  void asingEventByDay(event){
    if (event["location"]["lat"]!=null){
      if (eventsByDay[event["start_date"]]==null){
        eventsByDay[event["start_date"]] = new List();
      }
      eventsByDay[event["start_date"]].add(event);

    }
  }
  
  void printlocation(event){
    //print(event["start_date"]);
    if (event["location"]["lat"]!=null){
      print(event["location"]);
    }else{
      print(event["city"]);
    }
  }
  
  void printEventByDay(){
    String day = "";
    List val;
    eventsData.forEach((event){
      if (day != event["start_date"]){
        day = event["start_date"];
        
        val = eventsByDay[day];

        if (val != null){
          daylist.add(day);
          //print("Dia: $day, size: '${val.length}'");
          val.forEach((event)=>printlocation(event));
        }
      }
    });

  }
  
  GMap themap;
  var circulos;
  void showMap(){
    js.scoped((){
      final mapOptions = new MapOptions()
      ..zoom = 2
      ..center = new LatLng(30, 0)
      ..mapTypeId = MapTypeId.ROADMAP
      ;
    themap = jsw.retain(new GMap(query("#sample_container_id"), mapOptions));
    
    query("#slider").onChange.listen((e){
      addMarker();
    });
  });
  }
  List circles;
  
  void addMarker() {
    var d = daylist[int.parse(slider.value)];
    print(d);
    var cantidadDefacilitadores = new Map();
    var eventscount = 0;
    var encontrado = false;
    for (int n = 0; n < eventsData.length; n++){
      eventscount++;
      eventsData[n]["facilitators"].forEach((facil){
        cantidadDefacilitadores[facil["name"]] = 1;
      });
      if ((eventsData[n]["start_date"] == d)&&(!encontrado)){
        encontrado = true;
        print("Encontrado: $n");
        //n = eventsData.length;
      }if ((eventsData[n]["start_date"] != d)&&(encontrado)){
        n = eventsData.length;
      }
    }
    
    var facilitatorscanvas = query("#facilitatorscanvas");
    facilitatorscanvas.nodes.clear();
    for (int n = 0; n<cantidadDefacilitadores.length; n++){
      var img = new ImageElement();
      img.src = "legoman.png";
      facilitatorscanvas.nodes.add(img);
    }
    
    query("#eventoscount").text = "$eventscount";
    query("#facilitatorscount").text = "${cantidadDefacilitadores.length}";
    
    DateTime dt = DateTime.parse(d);
    query("#title").text = "${dt.year}/${dt.month}/${dt.day}";
    
    js.scoped(() {
      var day = int.parse(slider.value);
      var days = eventsByDay[daylist[day]];
      
      //print(days);
      circles.forEach((e)=>e.map = null);
      circles.clear();
      days.forEach((cir){
        var center = new LatLng(cir["location"]["lat"], cir["location"]["lng"]);
        final opt =  new CircleOptions()
        ..center = center
        ..strokeColor = '#FF0000'
        ..strokeOpacity = 0.8
        ..strokeWeight = 2
        ..fillColor = '#FF0000'
        ..fillOpacity = 0.35
        ..radius = 100000
        ..map = themap;
        Circle circle = new Circle(opt);
        jsw.retain(circle);
        
        circles.add(circle);
      });
      
      if (day-1>=0){
        day--;
        
        var days = eventsByDay[daylist[day]];
        days.forEach((cir){
          var center = new LatLng(cir["location"]["lat"], cir["location"]["lng"]);
          final opt =  new CircleOptions()
          ..center = center
          ..strokeColor = '#FF0000'
          ..strokeOpacity = 0.6
          ..strokeWeight = 2
          ..fillColor = '#FF0000'
          ..fillOpacity = 0.30
          ..radius = 200000
          ..map = themap;
          Circle circle = new Circle(opt);
          jsw.retain(circle);
          
          circles.add(circle);
        });
      }
      
      if (day-1>=0){
        day--;
        
        var days = eventsByDay[daylist[day]];
        days.forEach((cir){
          var center = new LatLng(cir["location"]["lat"], cir["location"]["lng"]);
          final opt =  new CircleOptions()
          ..center = center
          ..strokeColor = '#FF0000'
          ..strokeOpacity = 0.4
          ..strokeWeight = 2
          ..fillColor = '#FF0000'
          ..fillOpacity = 0.25
          ..radius = 400000
          ..map = themap;
          Circle circle = new Circle(opt);
          jsw.retain(circle);
          
          circles.add(circle);
        });
      }
      
      if (day-1>=0){
        day--;
        
        var days = eventsByDay[daylist[day]];
        days.forEach((cir){
          var center = new LatLng(cir["location"]["lat"], cir["location"]["lng"]);
          final opt =  new CircleOptions()
          ..center = center
          ..strokeColor = '#FF0000'
          ..strokeOpacity = 0.2
          ..strokeWeight = 2
          ..fillColor = '#FF0000'
          ..fillOpacity = 0.20
          ..radius = 600000
          ..map = themap;
          Circle circle = new Circle(opt);
          jsw.retain(circle);
          
          circles.add(circle);
        });
      }
      
      if (day-1>=0){
        day--;
        
        var days = eventsByDay[daylist[day]];
        days.forEach((cir){
          var center = new LatLng(cir["location"]["lat"], cir["location"]["lng"]);
          final opt =  new CircleOptions()
          ..center = center
          ..strokeColor = '#FF0000'
          ..strokeOpacity = 0.1
          ..strokeWeight = 2
          ..fillColor = '#FF0000'
          ..fillOpacity = 0.15
          ..radius = 800000
          ..map = themap;
          Circle circle = new Circle(opt);
          jsw.retain(circle);
          
          circles.add(circle);
        });
      }
    });
  }
}