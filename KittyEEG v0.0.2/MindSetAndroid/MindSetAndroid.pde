//required for BT enabling on startup
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;

KetaiBluetooth bt;
String info = "";
KetaiList klist;
PVector remoteMouse = new PVector();

ArrayList<String> devicesDiscovered = new ArrayList();
boolean isConfiguring = true;
String UIText;
float j = 0;
int raw = 0;
float oldj = 0;
int oldraw = 0;

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//********************************************************************

void setup()
{   
  orientation(PORTRAIT);
  background(78, 93, 75);
  stroke(255);
  textSize(24);

  //start listening for BT connections
  bt.start();
  
  UIText =  "d - discover devices\n" +
    "b - make this device discoverable\n" +
    "c - connect to device\n     from discovered list.\n" +
    "p - list paired devices\n" +
    "i - Bluetooth info";
}

void draw()
{
  if (isConfiguring)
  {
    ArrayList<String> names;
    background(78, 93, 75);

    //based on last key pressed lets display
    //  appropriately
    if (key == 'i')
      info = getBluetoothInformation();
    else
    {
      if (key == 'p')
      {
        info = "Paired Devices:\n";
        names = bt.getPairedDeviceNames();
      }
      else
      {
        info = "Discovered Devices:\n";
        names = bt.getDiscoveredDeviceNames();
      }

      for (int i=0; i < names.size(); i++)
      {
        info += "["+i+"] "+names.get(i).toString() + "\n";
      }
    }
    text(UIText + "\n\n" + info, 5, 90);
  }
  else
  {
    
    line(oldj,oldraw/10+400,j,raw/10+400); 
    oldj = j;
    oldraw = raw;
    if (j>502){
     oldraw = 0;
     oldj = 0;
     background(78, 93, 75);
    }
    
    pushStyle();
    fill(255);
    ellipse(mouseX, mouseY, 20, 20);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    ellipse(remoteMouse.x, remoteMouse.y, 20, 20);   
    popStyle();
  }

  drawUI();
}

String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }
  return btInfo;
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  if (isConfiguring)
    return;
  
    int datalength = data.length;
    int value[] = new int[datalength];
    
    //println("length: "+datalength);
    for (int i=0; i<datalength; i++){
      value[i] = data[i];
      if (data[i]<0)
        value[i] = data[i]+256;
      //println("data "+i+": "+value[i]); 
    }

    for (int i=0; i<(datalength-1); i++){
      if (value[i]==170){
        if (value[i+1]==170){
          if (value[i+3]==128){
            raw = value[i+5]*256+value[i+6];
            if (raw >= 32768)
              raw = raw - 65536;
              //println("raw: "+raw);
            j = j + 0.1;
            println(j);
            if (j>512)
             j = 0;
          }
        }
      }      
    }
}
