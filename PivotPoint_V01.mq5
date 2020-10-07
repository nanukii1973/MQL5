//pivot point แบบ basic ที่สุด.. ใน ver. ต่อไปตั้งใจว่าจะใส่ สูตรคํานวน แบบอื่นๆลงไป
//-------------------------------------------------------------------------
#property indicator_chart_window

datetime checkDay;
string nPP="PP";
string nR1="R1";
string nR2="R2";
string nR3="R3";
string nS1="S1";
string nS2="S2";
string nS3="S3";
//---
int OnInit()
  {
   lineCreate(nPP,clrTeal,1,0,0,0);
   lineCreate(nR1,clrSeaGreen,1,0,0,0);
   lineCreate(nR2,clrOliveDrab,1,0,0,0);
   lineCreate(nR3,clrForestGreen,1,0,0,0);
   lineCreate(nS1,clrDarkGoldenrod,1,0,0,0);
   lineCreate(nS2,clrGoldenrod,1,0,0,0);
   lineCreate(nS3,clrDarkOrange,1,0,0,0);
   return(INIT_SUCCEEDED);
  }
//---
void OnDeinit(const int reason)
  {
   int total=ObjectsTotal(0);
   for(int i=0;i<total;i++)
     {
    ObjectsDeleteAll(0,"Line");
     }
  }
//---
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
                
  {
      MqlRates rates[];
      MqlDateTime dt;
      datetime D1=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" 00:15:00");
      TimeToStruct(TimeCurrent(),dt);
      datetime D2=iTime(_Symbol,PERIOD_CURRENT,0);
      double PV=iClose(_Symbol,PERIOD_D1,1);
      
      double LastHigh, LastLow, LastClose;
      double PP, R1, R2, R3, S1, S2, S3;
         LastHigh=iHigh(_Symbol,PERIOD_D1,1);
         LastLow=iLow(_Symbol,PERIOD_D1,1);
         LastClose=iClose(_Symbol,PERIOD_D1,1);
         
         PP=(LastHigh+LastLow+LastClose)/3;
         R1=(PP*2.0)-LastLow;
         R2=PP+(LastHigh-LastLow);
         R3=LastHigh+((PP-LastLow)*2.0);
         
         S1=(PP*2.0)-LastHigh;
         S2=PP-(LastHigh-LastLow);
         S3=LastLow-((LastHigh-PP)*2.0);   
     
     datetime lastDay=iTime(_Symbol,PERIOD_D1,1); 
   if(checkDay!=lastDay)
      {
       lineMove(nPP,clrCyan,PP,D1,D2); 
       lineMove(nR1,clrCyan,R1,D1,D2);
       lineMove(nR2,clrCyan,R2,D1,D2);
       lineMove(nR3,clrCyan,R3,D1,D2);
       lineMove(nS1,clrCyan,S1,D1,D2);
       lineMove(nS2,clrCyan,S2,D1,D2);
       lineMove(nS3,clrCyan,S3,D1,D2);

       checkDay=lastDay;
      }
   return(rates_total);
  }
//---
bool lineCreate(
                const string name,
                const color Lcolor,
                const int width,
                const double pPrince,
                const datetime D1,
                const datetime D2
                )
   {    
      ObjectCreate(0,"Line_"+name,OBJ_TREND,0,D1,pPrince,D2+2000,pPrince);
      ObjectSetInteger(0,"Line_"+name,OBJPROP_COLOR,Lcolor);
      ObjectSetInteger(0,"Line_"+name,OBJPROP_WIDTH,width);
      ObjectSetInteger(0,"Line_"+name,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,"Line_"+name,OBJPROP_STYLE,STYLE_DOT);
      //---------------------------------------------------------------
      ObjectSetString(0,"Line_Label_"+name,OBJPROP_FONT,"Arial Bold");
      ObjectCreate(0,"Line_Label_"+name,OBJ_TEXT,0,D2+4000,0);
      ObjectSetInteger(0,"Line_Label_"+name,OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,"Line_Label_"+name,OBJPROP_BGCOLOR,clrBlack);
      ObjectSetString(0,"Line_Label_"+name,OBJPROP_TEXT,name);
      ObjectSetDouble(0,"Line_Label_"+name,OBJPROP_PRICE,pPrince);
      ObjectSetInteger(0,"Line_Label_"+name,OBJPROP_ANCHOR,ANCHOR_LEFT);
       
      return(true);
   } 
//---
bool lineMove(
                const string name,
                const color Lcolor,
                const double pPrince,
                const datetime D1,
                const datetime D2
                )
   {     
      ObjectMove(0,"Line_"+name,0,D1,pPrince);
      ObjectMove(0,"Line_"+name,1,D2+3600,pPrince);      
      ObjectMove(0,"Line_Label_"+name,0,D2+3600,pPrince);
      
      return(true);
   }    
   
