import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:async';

class BinaryClock extends WebComponent {

  String _value = "null";
  int _size = 256;
  CanvasElement _ca;  
  CanvasRenderingContext2D _crc;
  Timer _atimer = null;
  int _style = 1;
  List<String> _history = new List<String>();
  
  String get value{draw();return _value;  }
  void set value(String newval){ 
    _value = newval; 
    initTime();    
    }
  
  initTime() {
    if(_atimer==null){
      _atimer = new Timer.periodic(new Duration(milliseconds:1000), (Timer timer) => updateTime());
    }
    draw();
  }  
 
  void draw() {
    
    if (_ca == null)
    {
      _ca = getShadowRoot("x-binaryclock").query("#surface");
      if (_ca==null) return;
    }
    
    if (_crc == null){
      _crc= _ca.getContext("2d");
      if (_crc==null) return;
    }
      
    int rows = 0;
    int startcol = 255;
    int square = 8;
    for (String bintime in _history.reversed)
    {
      if (_style==0){
      _crc.font = "bold 12pt Courier";
      _crc.fillStyle = 'rgb(0, 0, 0)';
      _crc.fillText("$_value", 12, 18);
      }
      else if (_style==1){
        
        int v = (startcol - rows*10);
        int vv = 255- (startcol - rows*10);
        
        for(int i=0;i<bintime.length;i++){
          String ch = bintime[i];
          //int vi = 255-v;
          if (ch=="1") 
            _crc.fillStyle = 'rgb(255, $v, $vv)';
          else
            _crc.fillStyle = 'rgb($v, 255, 255)';
          
          _crc.fillRect(i*square, rows*square, square, square);
          _crc.fillRect((384-square) - i*square, rows*square, square, square);
          
          _crc.strokeStyle = 'rgb(225, 225, 225)';
          _crc.strokeRect(i*square, rows*square, square, square);
          _crc.strokeRect((384-square) - i*square, rows*square, square, square);
        }
      
      }
      else if (_style==2){
        
        int v = (startcol - rows*10);
        int vv = 255- (startcol - rows*10);
        for(int i=0;i<bintime.length;i++){
          String ch = bintime[i];
          //int vi = 255-v;
          if (ch=="1")
            _crc.fillStyle = 'rgb(255, $v, $vv)';
          else
            _crc.fillStyle = 'rgb($v, 255, 255)';
        
          _crc.beginPath();
          _crc.arc(i*square, rows*square, square/4, 0, 6.28, false);
          //_crc.fillStyle = 'green';
          _crc.fill();
          _crc.lineWidth = 1;
          _crc.strokeStyle = '#003300';
          _crc.stroke();
        }
      }
      rows++;
    }
  
  
  }
    
 void updateTime()
 {
   int numtime = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
   String binary = numtime.toRadixString(2);
   //print(binary.substring(binary.length-24));
   _value = binary.substring(binary.length-24);
   _history.add(_value);
   //print("adding [$_value]");
   if (_history.length>24) _history.removeAt(0);   
   draw();
 }
  
  
}
