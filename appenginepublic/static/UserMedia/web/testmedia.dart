import 'dart:html';
import 'dart:async';

VideoElement theVideo;
CanvasElement theCanvas,theGraph;
CanvasRenderingContext2D theContext,gContext;

void main() {
  theVideo = query("#thevideo");
  theCanvas = query("#theCanvas");
  theGraph = query("#thegraph");
  
  theContext = theCanvas.getContext("2d");
  gContext = theGraph.getContext("2d");
  if ( MediaStream.supported ){
    window.navigator.getUserMedia(
        audio: false, video: 
          {'mandatory':
            { 'minAspectRatio': 1.333, 'maxAspectRatio': 1.334 },
           'optional': [{ 'minFrameRate': 60 }, { 'maxWidth': 400 }]
          }
      ).then((stream) {
      theVideo
        ..autoplay = true
        ..src = Url.createObjectUrlFromStream(stream);
      new Timer(new Duration(milliseconds: 100),procesImage);
    });
  }else{
    query("body").nodes.add ( new Element.html ("<p>Html5 full suppor is not supported you should change to chrome or something. These is a table of the support of the features needed: <a href='http://caniuse.com/stream'>features</a> </p>"));
  }
}

var red = new Map();
var blue = new Map();
var green = new Map();
var alpha = new Map();
var max = 0,maxH = 0;

void procesImage(){
  theContext.drawImage(theVideo, 0, 0);
  var d = theContext.getImageData(0, 0, 400, 300);
  var h = d.height;
  var w = d.width;
  red = new Map<String, int>();
  blue = new Map<String, int>();
  green = new Map<String, int>();
  alpha = new Map<String, int>();
  max = 0;
  
  for(var y = 0; y < h; y++) {
    // loop through each column
    for(var x = 0; x < w; x++) {
      var r = d.data[((w * y) + x) * 4];
      var g = d.data[((w * y) + x) * 4 + 1];
      var b = d.data[((w * y) + x) * 4 + 2];
      var a = d.data[((w * y) + x) * 4 + 3];
      
      addNum(r,red);
      addNum(b,blue);
      addNum(g,green);
      
    }
  }
  
  normalizeMaxH([red,blue,green]);
  
  gContext.clearRect ( 0 , 0 , 400 , 300 );
  printStrokeForMap(red,"#ff0000");
  printStrokeForMap(blue,"#0000ff");
  printStrokeForMap(green,"#00ff00");

  new Timer(new Duration(milliseconds: 5),procesImage);
}

void normalizeMaxH(List<Map<String,int>> list){
  maxH = 0;
  for(var y = 0; y < list.length; y++) {
    Map m = list[y];
    for(var x = 1; x < max; x++) {
      var v = m["$x"];
      var val = v == null ? 0:v;
      maxH = maxH < val ? val : maxH;
    }
  }
}

void addNum(int n, Map<String, int> m){
  max = max <n?n:max;
  var str = "$n";
  m.putIfAbsent(str, ()=>m[str]=0);
  m[str] = m[str]+1;
}
void printStrokeForMap(Map<String, int> map, String style){
  gContext.beginPath();
  gContext.moveTo(0, 0);
  for (var x = 1; x < max; x++){

    var v = map["$x"];
    var val = v == null ? 0:v;
    gContext.lineTo(x, 300-(val*300/maxH));
  }
  gContext.strokeStyle = style;
  gContext.stroke();
}


