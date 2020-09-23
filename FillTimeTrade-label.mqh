#define  OBJ_NAME "time_left_label"
//+------------------------------------------------------------------+
void DeleteLabel()
{
   int try=10;
   while(ObjectFind(0,OBJ_NAME)==0)
   {
      ObjectDelete(0,OBJ_NAME);
      if(try--<=0)break;
   }
 }  
//+------------------------------------------------------------------+
int OnInit()
{

//+------------------------------------------------------------------+
   EventSetTimer(1);
   DeleteLabel();

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   DeleteLabel();
}
//-------------------------------------------------------
void OnTick()
  {
   addLabel(timeToTrade());
  }
//-------------------------------------------------------
void addLabel(bool timeToTrade)
  {
      ObjectCreate(0,OBJ_NAME,OBJ_LABEL,0,0,0);
      if(timeToTrade==true)
      {
         ObjectCreate(0,OBJ_NAME,OBJ_LABEL,0,0,0);
         ObjectSetString(0,OBJ_NAME,OBJPROP_TEXT,"TRADING");
         ObjectSetString(0,OBJ_NAME,OBJPROP_FONT,"Hack");
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_COLOR,clrLimeGreen);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_FONTSIZE,12);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_XDISTANCE,50);
      }
      if(timeToTrade==false)
      {
         ObjectSetString(0,OBJ_NAME,OBJPROP_TEXT,"Wait Market!!");
         ObjectSetString(0,OBJ_NAME,OBJPROP_FONT,"Hack");
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_COLOR,clrOrangeRed);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_FONTSIZE,12);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,OBJ_NAME,OBJPROP_XDISTANCE,50);
      }    
  }
  
bool timeToTrade()
  {
    datetime thisTime=TimeCurrent();
    datetime startTrade=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" 07:00");
    datetime stopTrade=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" 20:59");
    
    if(thisTime>startTrade && thisTime<stopTrade) return true;
    else return false;
  } 
    /*----------------------------------------------
    | Forex trading hours, Forex trading time GTM:
    |______________________________________________
    | London opens at 07:00 am to 15:59 noon
    | New York opens at 12:00 am to 20:59 pm
    | Tokyo opens at 23:00 pm to 5:59 am
    | Sydney opens at 21:00 am to 5:59 pm
    -----------------------------------------------*/  
