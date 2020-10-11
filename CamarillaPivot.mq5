#property indicator_chart_window

datetime checkDay;
string nPP = "PP";
string nR1 = "R1";
string nR2 = "R2";
string nR3 = "R3";
string nR4 = "R4";
string nS1 = "S1";
string nS2 = "S2";
string nS3 = "S3";
string nS4 = "S4";

int barCheck;
datetime lastWeek;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   int total = ObjectsTotal(0);
   for(int i = 0; i < total; i++)
     {
      ObjectsDeleteAll(0, "Line");
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
//datetime D1=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" 00:15:00");
   datetime D1 = iTime(NULL, PERIOD_W1, 0) + PeriodSeconds(PERIOD_D1);
   TimeToStruct(TimeCurrent(), dt);
   datetime D2 = iTime(_Symbol, PERIOD_CURRENT, 0);
   double PV = iClose(_Symbol, PERIOD_W1, 1);

   double LastHigh, LastLow, LastClose;
   double PP, R1, R2, R3, R4, S1, S2, S3, S4;
   LastHigh = iHigh(_Symbol, PERIOD_W1, 1);
   LastLow = iLow(_Symbol, PERIOD_W1, 1);
   LastClose = iClose(_Symbol, PERIOD_W1, 1);

   datetime thisWeek = iTime(NULL, PERIOD_W1, 0);
   string T1 = TimeToString(iTime(NULL, PERIOD_W1, 0), TIME_DATE);
   Comment(T1);

   if(thisWeek != lastWeek)
     {
      createAllLine();
      lastWeek = thisWeek;
     }

   PP = (LastHigh + LastLow + LastClose) / 3;
   R1 = (LastHigh - LastLow) * (1.1 / 12) + LastClose;
   R2 = (LastHigh - LastLow) * (1.1 / 6) + LastClose;
   R3 = (LastHigh - LastLow) * (1.1 / 4) + LastClose;
   R4 = (LastHigh - LastLow) * (1.1 / 2) + LastClose;

   S1 = LastClose - (LastHigh - LastLow) * (1.1 / 12);
   S2 = LastClose - (LastHigh - LastLow) * (1.1 / 6);
   S3 = LastClose - (LastHigh - LastLow) * (1.1 / 4);
   S4 = LastClose - (LastHigh - LastLow) * (1.1 / 2);

   datetime lastDay = iTime(_Symbol, PERIOD_D1, 1);
   int bar = iBars(_Symbol, PERIOD_CURRENT);
   if(barCheck != bar)
     {
      lineMove(nPP, clrCyan, PP, D1, D2, T1);
      lineMove(nR1, clrCyan, R1, D1, D2, T1);
      lineMove(nR2, clrCyan, R2, D1, D2, T1);
      lineMove(nR3, clrCyan, R3, D1, D2, T1);
      lineMove(nR4, clrCyan, R4, D1, D2, T1);
      lineMove(nS1, clrCyan, S1, D1, D2, T1);
      lineMove(nS2, clrCyan, S2, D1, D2, T1);
      lineMove(nS3, clrCyan, S3, D1, D2, T1);
      lineMove(nS4, clrCyan, S4, D1, D2, T1);

      barCheck = bar;
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool lineCreate(
   const string name,
   const color Lcolor,
   const int width,
   const double pPrince,
   const datetime D1,
   const datetime D2,
   const string T1)
  {
   ObjectCreate(0, "Line_" + name + "_" + T1, OBJ_TREND, 0, D1, pPrince, D2 + 2000, pPrince);
   ObjectSetInteger(0, "Line_" + name + "_" + T1, OBJPROP_COLOR, Lcolor);
   ObjectSetInteger(0, "Line_" + name + "_" + T1, OBJPROP_WIDTH, width);
   ObjectSetInteger(0, "Line_" + name + "_" + T1, OBJPROP_STYLE, STYLE_SOLID);
//---------------------------------------------------------------
   ObjectSetString(0, "Line_Label_" + name + "_" + T1, OBJPROP_FONT, "Arial Bold");
   ObjectCreate(0, "Line_Label_" + name + "_" + T1, OBJ_TEXT, 0, D2 + 4000, 0);
   ObjectSetInteger(0, "Line_Label_" + name + "_" + T1, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, "Line_Label_" + name + "_" + T1, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, "Line_Label_" + name + "_" + T1, OBJPROP_BGCOLOR, clrBlack);
   ObjectSetString(0, "Line_Label_" + name + "_" + T1, OBJPROP_TEXT, name);
   ObjectSetDouble(0, "Line_Label_" + name + "_" + T1, OBJPROP_PRICE, pPrince);
   ObjectSetInteger(0, "Line_Label_" + name + "_" + T1, OBJPROP_ANCHOR, ANCHOR_LEFT);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool lineMove(
   const string name,
   const color Lcolor,
   const double pPrince,
   const datetime D1,
   const datetime D2,
   const string T1)
  {
   ObjectMove(0, "Line_" + name + "_" + T1, 0, D1, pPrince);
   ObjectMove(0, "Line_" + name + "_" + T1, 1, D2 + 3600, pPrince);
   ObjectMove(0, "Line_Label_" + name + "_" + T1, 0, D2 + 3600, pPrince);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool createAllLine()
  {
   string T1 = TimeToString(iTime(NULL, PERIOD_W1, 0), TIME_DATE);
   lineCreate(nPP, clrTeal, 1, 0, 0, 0, T1);
   lineCreate(nR1, clrSeaGreen, 1, 0, 0, 0, T1);
   lineCreate(nR2, clrOliveDrab, 1, 0, 0, 0, T1);
   lineCreate(nR3, clrOliveDrab, 1, 0, 0, 0, T1);
   lineCreate(nR4, clrForestGreen, 1, 0, 0, 0, T1);
   lineCreate(nS1, clrDarkGoldenrod, 1, 0, 0, 0, T1);
   lineCreate(nS2, clrGoldenrod, 1, 0, 0, 0, T1);
   lineCreate(nS3, clrGoldenrod, 1, 0, 0, 0, T1);
   lineCreate(nS4, clrDarkOrange, 1, 0, 0, 0, T1);

   return(true);
  }
//+------------------------------------------------------------------+
