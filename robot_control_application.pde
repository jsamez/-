
//required for BT enabling on startup
import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

import controlP5.*;
ControlP5 cp5;

KetaiBluetooth bt;
String info = "";
KetaiList klist;

boolean isConfiguring = true;
String ctlkey;

int counter= 0;

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
  fullScreen();
  //orientation(PORTRAIT);
  orientation(LANDSCAPE);
  background(78, 93, 75);
  stroke(255);
  textSize(16*((int)displayDensity));

  //start listening for BT connections
  bt.start();

  PFont pfont = createFont("Candara", 40, true);
  ControlFont font = new ControlFont(pfont, 12*((int)displayDensity));
  
  cp5 = new ControlP5(this);
  cp5.setFont(font);

  cp5.addButton("discover")
    .setCaptionLabel("Discover")
    .setPosition(10, 50)
    .setSize(200, 120);

  cp5.addButton("discoverable")
    .setCaptionLabel("Discoverable")
    .setPosition(250, 50)
    .setSize(200, 120);

  cp5.addButton("btconnect")
    .setCaptionLabel("Connect")
    .setPosition(500, 50)
    .setSize(200, 120);

  cp5.addButton("btpair")
    .setCaptionLabel("Paired")
    .setPosition(750, 50)
    .setSize(200, 120);

  cp5.addButton("btinfo")
    .setCaptionLabel("Info")
    .setPosition(1000, 50)
    .setSize(200, 120);

  cp5.addButton("btstop")
    .setCaptionLabel("Stop")
    .setPosition(1250, 50)
    .setSize(200, 120);

  cp5.addButton("btcontrol")
    .setCaptionLabel("Control")
    .setPosition(1500, 50)
    .setSize(200, 120);

  cp5.addButton("btclose")
    .setCaptionLabel("Exit")
    .setPosition(1750, 50)
    .setSize(200, 120);

  cp5.addButton("Next_action")
    .setCaptionLabel("  Next_Action")
    .setPosition(1500, 500)
    .setSize(220, 120);

  cp5.addButton("Action")
    .setCaptionLabel("  Action")
    .setPosition(750, 500)
    .setSize(220, 120);
  
  cp5.addButton("Previous_action")
    .setCaptionLabel(" Previous_Action")
    .setPosition(1125, 500)
    .setSize(220, 120);
}

void draw()
{
  if (isConfiguring == true) {
    ArrayList<String> names;
    background(78, 93, 75);

    //based on last control command  lets display appropriately
    if (ctlkey == "info") {
      info = getBluetoothInformation();
    } else {
      if (ctlkey == "pair") {
        info = "Paired Devices:\n";
        names = bt.getPairedDeviceNames();
      } else {
        info = "Discovered Devices:\n";
        names = bt.getDiscoveredDeviceNames();
      }
      for (int i=0; i < names.size(); i++) {
        info += "["+i+"] "+names.get(i).toString() + "\n";
      }
    }
    textSize(16*((int)displayDensity));
    text(info, 5, 300);
  } else {
    background(78, 93, 75);
  }
}

String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "Device Discovering:" + bt.isDiscovering();
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device : devices) {
    btInfo+= device+"\n";
  }

  return btInfo;
}

void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();

  if (!selection.equals("CANCEL")) {
    bt.connectToDeviceByName(selection);
  }

  //dispose of list for now
  klist = null;
}

void discover() {
  bt.discoverDevices();
  ctlkey = "dis";
  isConfiguring = true;
}

void discoverable() {
  bt.makeDiscoverable();
  isConfiguring = true;
}

void btconnect() {
  //If we have not discovered any devices, try prior paired devices
  if (bt.getDiscoveredDeviceNames().size() > 0) {
    ArrayList<String> list = bt.getDiscoveredDeviceNames();
    list.add("CANCEL");
    klist = new KetaiList(this, list);
  } else if (bt.getPairedDeviceNames().size() > 0) {
    ArrayList<String> list = bt.getPairedDeviceNames();
    list.add("CANCEL");
    klist = new KetaiList(this, list);
  }
  isConfiguring = true;
}

void btpair() {
  ctlkey = "pair";
  isConfiguring = true;
}

void btinfo() {
  ctlkey = "info";
  isConfiguring = true;
}

void btstop() {
  bt.stop();
}

void btcontrol() {
  ctlkey = "ctl";
  isConfiguring = false;
}

void btclose() {
  this.getActivity().finish();
}

void Next_action(){
  if (isConfiguring){
     if (counter == 6){
        counter = 0;
     }
   else{  counter= counter +1;
     }
   }
}

void Previous_action(){
  if (isConfiguring){
    if(counter == 0){
      counter = 6;
    }
    else{
    counter = counter -1;
    }
  }
}

void Action(){
  if (isConfiguring){
    if(counter == 0){
      button1();
  }
   else if(counter == 1){
     button2();
   }
   else if(counter == 2){
    button3();
  }
  else if(counter ==3){
   button4();
   }
   else if(counter == 4){
     button5();
   }
   else if(counter == 5){
     button6();
   }
   else if(counter == 6){
     button7();
   }
 }
}

void button7() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x80, (byte)0x80, (byte)0x80, 
(byte)0x80, (byte)0x82, (byte)0x88};   //Fire
  bt.broadcast(data);
}

void button3() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x80, (byte)0x82, (byte)0x80, 
(byte)0x80, (byte)0x80, (byte)0x08};   //Turn Left
  bt.broadcast(data);
}

void button1() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x02, (byte)0x80, (byte)0x80, 
(byte)0x80, (byte)0x80, (byte)0x01};   //Forward
  bt.broadcast(data);
}

void button2() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x82, (byte)0x80, (byte)0x80, 
(byte)0x80, (byte)0x80, (byte)0x02};   //Backward
  bt.broadcast(data);
}

void button4() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x80, (byte)0x02, (byte)0x80, 
(byte)0x80, (byte)0x80, (byte)0x04};   //Turn Right
  bt.broadcast(data);
}

void button5() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x80, (byte)0x80, (byte)0x82, 
(byte)0x80, (byte)0x80, (byte)0x22};   //Turret up
  bt.broadcast(data);
}

void button6() {
  byte[] data = {(byte)0x71, (byte)0x00, (byte)0x80, (byte)0x80, (byte)0x02, 
(byte)0x80, (byte)0x80, (byte)0x12};   //Turret down
  bt.broadcast(data);
}
