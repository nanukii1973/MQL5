#include <\Trade\Trade.mqh>

CTrade iTrade;

input int                  FastEMA=10; 
input int                  MidEMA=13;
input int                  SlowEMA=26;
input int                  TrendEMA=150;
input int                  AtrPreiod=20;
input double               StopX=1.0;
input double               TakeX=1.5;
input int         TimeStart=8; 
input int        TimeEnd=22;
input double     OpenFill=0.5;

//Optimize 15m EURUSDm lookGood//
//***เพิ่มตัวกรองเงื่อนไขการเปิดOrder***//
//----------------------------------------------------//
//double StopLevel=NormalizeDouble((SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point),_Digits);

#define  OBJ_NAME "time_left_label"


string Signal="";
double EmaFastArray[] ,EmaSlowArray[], EmaMidArray[], EmaTrendArray[],
       AtrArray[], HighArray[], LowArray[], OpenArray[], CloseArray[];

int barCheck1=0;
int barCheck2=0;
int barCheck3=0;
int barCheck4=0;
void OnTick()
  {   
      int Bar=Bars(_Symbol,PERIOD_CURRENT);
    //TrailingStop();
    //Comment(Signal_2xEma());

      
      int EmaFastDef=iMA(_Symbol,PERIOD_CURRENT,FastEMA,0,MODE_EMA,PRICE_CLOSE);   
      int EmaMidDef=iMA(_Symbol,PERIOD_CURRENT,MidEMA,0,MODE_EMA,PRICE_CLOSE);
      int EmaSlowDef=iMA(_Symbol,PERIOD_CURRENT,SlowEMA,0,MODE_EMA,PRICE_CLOSE);
      int EmaTrendDef=iMA(_Symbol,PERIOD_CURRENT,TrendEMA,0,MODE_EMA,PRICE_CLOSE);
      int AtrDef=iATR(_Symbol,PERIOD_CURRENT,AtrPreiod);      
      
      ArraySetAsSeries(EmaFastArray,true);
      ArraySetAsSeries(EmaMidArray,true);
      ArraySetAsSeries(EmaSlowArray,true);
      ArraySetAsSeries(EmaTrendArray,true);
      ArraySetAsSeries(AtrArray,true);
      ArraySetAsSeries(HighArray,true);
      ArraySetAsSeries(LowArray,true);
      ArraySetAsSeries(OpenArray,true);
      ArraySetAsSeries(CloseArray,true);

      CopyBuffer(EmaFastDef,0,0,3,EmaFastArray);
      CopyBuffer(EmaMidDef,0,0,3,EmaMidArray);
      CopyBuffer(EmaSlowDef,0,0,3,EmaSlowArray);
      CopyBuffer(EmaTrendDef,0,0,3,EmaTrendArray);
      CopyBuffer(AtrDef,0,0,3,AtrArray);
      
      CopyHigh(_Symbol,PERIOD_CURRENT,0,6,HighArray);
      CopyLow(_Symbol,PERIOD_CURRENT,0,6,LowArray);
      CopyOpen(_Symbol,PERIOD_CURRENT,0,6,OpenArray);
      CopyClose(_Symbol,PERIOD_CURRENT,0,6,CloseArray);
      
      double Highest5Back=HighArray[ArrayMaximum(HighArray,1,5)];
      double Lowest5Back=LowArray[ArrayMinimum(LowArray,1,5)];

      //-------------------------------------------//
      addLabel(timeToTrade());
      //StopLoss8x5();  
      //-------------------------------------------//
       if(PositionsTotal()<1 && timeToTrade()==true)
         {
         
         //int Bar=Bars(_Symbol,PERIOD_CURRENT);         
            double u01, u02, s01, s02;
            u01=EmaFastArray[0]-EmaSlowArray[0];
            u02=EmaFastArray[2]-EmaSlowArray[2];
            s01=EmaSlowArray[0]-EmaFastArray[0];
            s02=EmaSlowArray[2]-EmaFastArray[2];
            
            
            
            
           if(barCheck1!=Bar)
              {      
                if(EmaFastArray[1]>EmaMidArray[1] && EmaMidArray[1]>EmaSlowArray[1] && EmaFastArray[1]>EmaTrendArray[1]
                    && EmaFastArray[0]>EmaMidArray[0] && EmaMidArray[0]>EmaSlowArray[0] && u01>=u02*OpenFill)
                  {
                   if(CloseArray[2]>EmaFastArray[2] && CloseArray[1]<EmaFastArray[1])// 
                     {
                       Signal="BUY";
                    //Comment("************************BUY**************************");           
                     }
                  } 
               else if(EmaFastArray[1]<EmaMidArray[1] && EmaMidArray[1]<EmaSlowArray[1] && EmaFastArray[1]<EmaTrendArray[1]  
                  && EmaFastArray[0]<EmaMidArray[0] && EmaMidArray[0]<EmaSlowArray[0] && s01>=s02*OpenFill)
                  {
                    if(CloseArray[2]<EmaFastArray[2] && CloseArray[1]>EmaFastArray[1])// 
                      {
                       Signal="SELL";
                       //Comment("************************SELL**************************");
                      }
                  } 
                  else
                    {
                     Signal="Waiting Signal...!!!";
                    }
                    barCheck1=Bar;                  
              }
        
        }
      //--------------------------------------------------------------------------------------------//
      if(Signal=="BUY"&& PositionsTotal()<1)
        {
         
         int spred=SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);         
         
         double SL=NormalizeDouble((LowArray[1]-AtrArray[1]),_Digits)+(spred*_Point);
         double TP=NormalizeDouble(Highest5Back+(((Highest5Back-(LowArray[1]*StopX))+AtrArray[1])*TakeX),_Digits)+(spred*_Point);

         int Total=OrdersTotal();
         //int barCheck=0;        
         if(barCheck2!=Bar)
          //(TypeOrder==ORDER_TYPE_SELL_STOP)
            {
            if(Total!=0)
              {
               ulong ticket=OrderGetTicket(0);
               string TypeOrder=(OrderGetInteger(ORDER_TYPE));

               for(int i=0;i<Total;i++)
                  {
                  if((ticket=OrderGetTicket(i))>0)
                    {
                     if(TypeOrder==ORDER_TYPE_BUY_STOP) iTrade.OrderDelete(ticket);
                     if(TypeOrder==ORDER_TYPE_SELL_STOP) iTrade.OrderDelete(ticket);
                     //if(TypeOrder==ORDER_TYPE_BUY_STOP) iTrade.OrderModify(ticket,Highest5Back+(spred*_Point),SL,TP,ORDER_TIME_DAY,0,0);
                    }                      
                  }                
              }
              iTrade.BuyStop(0.01,Highest5Back+(spred*_Point),NULL,SL,TP,ORDER_TIME_DAY);              
              barCheck2=Bar;              
            }
        Signal="Order Buy Now";
        } 
      //--------------------------------------------------------------------------------------------//  
      if(Signal=="SELL" && PositionsTotal()<1)  
        {
         int spred=SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);  
         double SL=NormalizeDouble((HighArray[1]+AtrArray[1]),_Digits)-(spred*_Point);
         double TP=NormalizeDouble(Lowest5Back-((((AtrArray[1]*StopX)+HighArray[1])-Lowest5Back)*TakeX),_Digits)-(spred*_Point);    
         int Total=OrdersTotal();
         if(barCheck3!=Bar)
          //
            {
             if(Total!=0)
              {
              ulong ticket=OrderGetTicket(0);
              string TypeOrder=(OrderGetInteger(ORDER_TYPE));                    
              
               for(int i=0;i<Total;i++)
                  {
                  if((ticket=OrderGetTicket(i))>0)
                    {
                     if(TypeOrder==ORDER_TYPE_BUY_STOP) iTrade.OrderDelete(ticket);                     
                     if(TypeOrder==ORDER_TYPE_SELL_STOP) iTrade.OrderDelete(ticket);
                     //if(TypeOrder==ORDER_TYPE_SELL_STOP) iTrade.OrderModify(ticket,Lowest5Back-(spred*_Point),SL,TP,ORDER_TIME_DAY,0,0);
                    }                         
                  } 
              }              
                iTrade.SellStop(0.01,Lowest5Back-(spred*_Point),NULL,SL,TP,ORDER_TIME_DAY);                            
                barCheck3=Bar;                        
            }
             Signal="Order Sell Now";
         }                         
          //StopLoss8x5(); 
          Comment(Signal);
  }

//--------------------------------------------------------------------------------------------//   
void StopLoss8x5()
    {
    if(PositionsTotal()!=0)
      {
        double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
        double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
        int totalPos=PositionsTotal();
        for(int i=0;i<totalPos;i++)
        {
            string thisSymbol=PositionGetSymbol(i);
            ulong PositionTicket = PositionGetInteger(POSITION_TICKET);
            double PriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
            double CurrentStopLoss = PositionGetDouble(POSITION_SL);
            double CurrentTakeProfit = PositionGetDouble(POSITION_TP);
            int StopLevel=SymbolInfoInteger(Symbol(),SYMBOL_TRADE_STOPS_LEVEL);
            int Bar=Bars(_Symbol,PERIOD_CURRENT); 
       //--------------------------------------------------------------//
       if(thisSymbol==_Symbol && barCheck4!=Bar)
          {
            //--------------------------------------------------------------//                
            if(PositionGetInteger(POSITION_TYPE)==0 && Ask<CurrentTakeProfit) //type=BUY
              {
                if(Ask>(PriceOpen+(CurrentTakeProfit-PriceOpen)*0.5))
                  {
                    iTrade.PositionModify(PositionTicket,(PriceOpen+(CurrentTakeProfit-PriceOpen)*0.3),CurrentTakeProfit);
                  }
              }
            //--------------------------------------------------------------//      
            else if(PositionGetInteger(POSITION_TYPE)==1 && Bid>CurrentTakeProfit) //type=SELL
              {
                if(Bid<(PriceOpen-(PriceOpen-CurrentTakeProfit)*0.5))
                  {
                    iTrade.PositionModify(PositionTicket,(PriceOpen-(PriceOpen-CurrentTakeProfit)*0.3),CurrentTakeProfit);
                  }                             
               }
                barCheck4=Bar;
            }
            //--------------------------------------------          
          }      
       }    
    }

//---------------------------------------------------------------------------------------
//+------------------------------------------------------------------+
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
      if(Signal!=0)
        {
         
        
      ObjectCreate(0,"Text01",OBJ_LABEL,0,0,0);
         ObjectSetString(0,"Text01",OBJPROP_TEXT,Signal);
         ObjectSetString(0,"Text01",OBJPROP_FONT,"Hack");
         ObjectSetInteger(0,"Text01",OBJPROP_COLOR,clrOrange);
         ObjectSetInteger(0,"Text01",OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,"Text01",OBJPROP_FONTSIZE,12);
         ObjectSetInteger(0,"Text01",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
         ObjectSetInteger(0,"Text01",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,"Text01",OBJPROP_XDISTANCE,300);            
         }
  }
  
bool timeToTrade()
  {
    string TStart=IntegerToString(TimeStart);
    string TEnd=IntegerToString(TimeEnd);
    datetime thisTime=TimeCurrent();
    datetime startTrade=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+TStart+":00");
    datetime stopTrade=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+TEnd+":00");
    
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
//---------------------------------------------------
