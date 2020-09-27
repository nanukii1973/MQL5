//+------------------------------------------------------------------+
//|                                               MACD-2 Classic.mq5 |
//|                             Copyright 2020-Forever, Nanukii1973. |
//|                                            Nanukii1973@gmail.com |
//|------------------------------------------------------------------|
//|   ดูวีดีโอสอนใน Youtube หลายๆคลิปพูดถึง Macd2 หาโหลดมีแต่หาตาประหลาด   |
//|   เลยทดลองดัดแปลงไฟล์ตัวอย่างของ MT5 ให้ออกมาเหมือนที่เคยเห็นใน MT4 :)   |
//+------------------------------------------------------------------+
#property copyright   "2020 - Forever"
#property link        "Nanukii1973@gmail.com"
#property description "MACD-2-Classic"
#include <MovingAverages.mqh>
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   4
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  clrMediumSeaGreen,clrCrimson
#property indicator_width1  2
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrYellowGreen
#property indicator_width2  1
#property indicator_style2  STYLE_SOLID 
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDeepPink
#property indicator_width3  1
#property indicator_style3  STYLE_DOT
//--- input parameters
input int                InpFastEMAPeriod=12;         // Fast EMA period
input int                InpSlowEMAPeriod=26;         // Slow EMA period
input int                InpSignalSMAPeriod=9;        // Signal SMA period
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_CLOSE; // Applied price
//--- indicator buffers
double                   ExtOsMABuffer[];
double                   ExtColorBuffer[];
double                   ExtMacdBuffer[];
double                   ExtSignalBuffer[];
double                   ExtFastMaBuffer[];
double                   ExtSlowMaBuffer[];
//--- MA handles
int                      ExtFastMaHandle;
int                      ExtSlowMaHandle;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtOsMABuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtColorBuffer,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2,ExtMacdBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ExtSignalBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,ExtFastMaBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,ExtSlowMaBuffer,INDICATOR_CALCULATIONS);
   //IndicatorSetInteger(INDICATOR_DIGITS,_Digits+2);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,InpSlowEMAPeriod+InpSignalSMAPeriod);   
//--- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"MACD-2x("+string(InpFastEMAPeriod)+","+string(InpSlowEMAPeriod)+","+string(InpSignalSMAPeriod)+")");
   PlotIndexSetString(0,PLOT_LABEL,"osMA");
   PlotIndexSetString(1,PLOT_LABEL,"Macd");
   PlotIndexSetString(2,PLOT_LABEL,"Signal");
//--- get MAs handles
   ExtFastMaHandle=iMA(NULL,0,InpFastEMAPeriod,0,MODE_EMA,InpAppliedPrice);
   ExtSlowMaHandle=iMA(NULL,0,InpSlowEMAPeriod,0,MODE_EMA,InpAppliedPrice);
//--- initialization done
  }
//+------------------------------------------------------------------+
//|  Moving Average of Oscillator                                    |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   if(rates_total<InpSignalSMAPeriod)
      return(0);
//--- not all data may be calculated
   int calculated=BarsCalculated(ExtFastMaHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtFastMaHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
   calculated=BarsCalculated(ExtSlowMaHandle);
   if(calculated<rates_total)
     {
      Print("Not all data of ExtSlowMaHandle is calculated (",calculated,"bars ). Error",GetLastError());
      return(0);
     }
//--- we can copy not all data
   int to_copy;
   if(prev_calculated>rates_total || prev_calculated<0) to_copy=rates_total;
   else
     {
      to_copy=rates_total-prev_calculated;
      if(prev_calculated>0) to_copy++;
     }
//--- get Fast EMA buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtFastMaHandle,0,0,to_copy,ExtFastMaBuffer)<=0)
     {
      Print("Getting fast EMA is failed! Error",GetLastError());
      return(0);
     }
//--- get SlowSMA buffer
   if(IsStopped()) return(0); //Checking for stop flag
   if(CopyBuffer(ExtSlowMaHandle,0,0,to_copy,ExtSlowMaBuffer)<=0)
     {
      Print("Getting slow SMA is failed! Error",GetLastError());
      return(0);
     }
//---
   int i,limit;
   if(prev_calculated==0)
      limit=0;
   else limit=prev_calculated-1;
//--- the main loop of calculations
   for(i=limit;i<rates_total;i++)
     {
      //--- calculate MACD
      ExtMacdBuffer[i]=ExtFastMaBuffer[i]-ExtSlowMaBuffer[i];
     }
//--- calculate Signal
   SimpleMAOnBuffer(rates_total,prev_calculated,0,InpSignalSMAPeriod,ExtMacdBuffer,ExtSignalBuffer);
//--- calculate OsMA
   for(i=limit;i<rates_total && !IsStopped();i++)
     {
      ExtOsMABuffer[i]=ExtMacdBuffer[i]-ExtSignalBuffer[i];
      
       if(ExtOsMABuffer[i]>0)   // set Color
         ExtColorBuffer[i]=0.0; // set color Green
      else
         ExtColorBuffer[i]=1.0; // set color Red
     }
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
