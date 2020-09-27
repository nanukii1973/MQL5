#define  OBJ_NAME "checkpin_"

int PinNum=0;

int BarCheck=0;
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    double Open[], Close[], High[], Low[];
    
    ArraySetAsSeries(Open,true);
    ArraySetAsSeries(Close,true);
    ArraySetAsSeries(High,true);
    ArraySetAsSeries(Low,true);
    
    CopyOpen(_Symbol,PERIOD_CURRENT,0,20,Open);
    CopyClose(_Symbol,PERIOD_CURRENT,0,20,Close);
    CopyHigh(_Symbol,PERIOD_CURRENT,0,20,High);
    CopyLow(_Symbol,PERIOD_CURRENT,0,20,Low);

    
    //double Body=MathAbs(Open[1]-Close[1]);
    double TailUp=MathAbs(High[1]-Close[1]);
    double TailDown=MathAbs(Close[1]-Low[1]);
    
    datetime MarkTime=iTime(_Symbol,PERIOD_CURRENT,1);
//---------------------------------------------------------//    
    double BUpper = High[1]-Open[1];
    double BBody = Open[1] - Close[1];
    double BLower = Close[1] - Low[1];
    double FullBody = BUpper + BBody + BLower;
//---------------------------------------
    if(Close[1]<Open[1])//red Bear
      {
       if(BLower>=BBody*7 && BUpper<=BLower*0.3)//Up
         {
            Comment("Bear Pin Up ",PinNum);
            addCheckPinBull(MarkTime,Low[1],"Up","Bear");
         }
       if(BUpper>=BBody*7 && BLower<=BUpper*0.3)//Down
         {
            Comment("Bear Pin Down ",PinNum);
            addCheckPinBull(MarkTime,High[1],"Down","Bear");
         }
      }
    if(Close[1] > Open[1])//green
      {       
       if(BLower>=BBody*7 && BUpper<=BLower*0.3)
         {
            Comment("Bull Pin Up ",PinNum);
            addCheckPinBull(MarkTime,Low[1],"Up","Bull");
         }
       if(BUpper>=BBody*7 && BLower<=BUpper*0.3)
         {
            Comment("Bull Pin Down ",PinNum);
            addCheckPinBull(MarkTime,High[1],"Down","Bull");
         }
      }    
  }
//+------------------------------------------------------------------+

void addCheckPinBull(datetime Marktime,double Price,string upORdown,string bullORbear)
    {
    string ArrowName=OBJ_NAME+PinNum;
    string TextName=OBJ_NAME+"text"+PinNum;
    int Bar=Bars(_Symbol,PERIOD_CURRENT);
    if(BarCheck!=Bar)
      {
       if(upORdown=="Up" && bullORbear=="Bull")
         {
          ArrowUpCreate(OBJ_ARROW_UP,0,ArrowName,0,Marktime,Price,ANCHOR_TOP,clrLimeGreen,STYLE_SOLID,5);
          TextCreate(0,TextName,0,Marktime,Price,"BullPinUp",10,clrWhite,ANCHOR_CENTER);
         }
       if(upORdown=="Up" && bullORbear=="Bear")
         {
          ArrowUpCreate(OBJ_ARROW_UP,0,ArrowName,0,Marktime,Price,ANCHOR_TOP,clrOrangeRed,STYLE_SOLID,5);
          TextCreate(0,TextName,0,Marktime,Price,"BearPinUp",10,clrWhite,ANCHOR_LOWER);
         }
       if(upORdown=="Down" && bullORbear=="Bull")
         {
          ArrowUpCreate(OBJ_ARROW_DOWN,0,ArrowName,0,Marktime,Price,ANCHOR_BOTTOM,clrOrangeRed,STYLE_SOLID,5);
          TextCreate(0,TextName,0,Marktime,Price,"BullPinDown",10,clrWhite,ANCHOR_LOWER);
         }
       if(upORdown=="Down" && bullORbear=="Bear")
         {
          ArrowUpCreate(OBJ_ARROW_DOWN,0,ArrowName,0,Marktime,Price,ANCHOR_BOTTOM,clrOrangeRed,STYLE_SOLID,5);
          TextCreate(0,TextName,0,Marktime,Price,"BearPinDown",10,clrWhite,ANCHOR_LOWER);
         }    
      PinNum++;
      BarCheck=Bar;
      }
    }
    
//+------------------------------------------------------------------+ 
//| Create Arrow Up sign                                             | 
//+------------------------------------------------------------------+ 
bool ArrowUpCreate(
                   const ENUM_OBJECT       ArrowType=OBJ_ARROW_UP,
                   const long              chart_ID=0,           // chart's ID 
                   const string            name="ArrowUp",       // sign name 
                   const int               sub_window=0,         // subwindow index 
                   datetime                time=0,               // anchor point time 
                   double                  Price=0,              // anchor point price 
                   const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor type 
                   const color             clr=clrRed,           // sign color 
                   const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style 
                   const int               width=3)              // sign size 
  {  
   ResetLastError(); 
//--- create the sign 
   if(!ObjectCreate(chart_ID,name,ArrowType,sub_window,time,Price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to create \"Arrow Up\" sign! Error code = ",GetLastError()); 
      //return(false); 
     } 
//--- set anchor type 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- set a sign color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set the border line style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- set the sign size 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 

   //ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,50); 
   return(true); 
  }   
  
bool TextCreate(const long              chart_ID=0,               // chart's ID 
                const string            Name="Text",              // object name 
                const int               sub_window=0,             // subwindow index 
                datetime                time=0,                   // anchor point time 
                double                  Price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                //const string            font="Arial",             // font 
                const int               font_size=10,             // font size 
                const color             clr=clrWhite,               // color 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER)
                //const ENUM_OBJECT_PROPERTY_INTEGER   Ydist=OBJPROP_YDISTANCE) // anchor type 
                //const bool              back=false)              // in the background 

  { 
//--- reset the error value 
   ResetLastError(); 
//--- create Text object 
   if(!ObjectCreate(chart_ID,Name,OBJ_TEXT,sub_window,time,Price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to create \"Text\" object! Error code = ",GetLastError()); 
      //return(false); 
     } 
//--- set the text 
   ObjectSetString(chart_ID,Name,OBJPROP_TEXT,text); 
//--- set text font 
   ObjectSetString(chart_ID,Name,OBJPROP_FONT,"Arial"); 
//--- set font size 
   ObjectSetInteger(chart_ID,Name,OBJPROP_FONTSIZE,font_size); 
   
   ObjectSetInteger(chart_ID,Name,OBJPROP_ANCHOR,anchor); 
//--- set color 
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,Name,OBJPROP_YDISTANCE,10); 

   return(true); 
  }  
