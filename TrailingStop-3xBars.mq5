#include <\Trade\Trade.mqh>

CTrade iTrade;

//----------------------------------------------------//

double StopLevel=NormalizeDouble((SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point),_Digits);
int barCheck=0;

void OnTick()
  {   
    TrailingStop();
  }
//----------------------------------------------------//
//             TrailingStop 3xBars
//----------------------------------------------------//

void TrailingStop()
  {
      int Bar=Bars(_Symbol,PERIOD_CURRENT);
      double barLow1, barLow2, barLow3, barHigh1, barHigh2, barHigh3;
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
      double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
      int totalPos=PositionsTotal();
          
      if(barCheck!=Bar)
        {
          //Comment("Do Someting 1time/1bar");
          barLow1=iLow(_Symbol,PERIOD_CURRENT,1);
          barLow2=iLow(_Symbol,PERIOD_CURRENT,2);
          barLow3=iLow(_Symbol,PERIOD_CURRENT,3);
          barHigh1=iHigh(_Symbol,PERIOD_CURRENT,1);
          barHigh2=iHigh(_Symbol,PERIOD_CURRENT,2);
          barHigh3=iHigh(_Symbol,PERIOD_CURRENT,3);
          
          barCheck=Bar;       
        }    
    //Comment(totalPos);
    for(int i=0;i<totalPos;i++)
      {
        string thisSymbol=PositionGetSymbol(i);
        ulong PositionTicket = PositionGetInteger(POSITION_TICKET);
        double PriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
        double CurrentStopLoss = PositionGetDouble(POSITION_SL);
        double CurrentTakeProfit = PositionGetDouble(POSITION_TP);
       //--------------------------------------------------------------//
       if(thisSymbol==_Symbol)
          {
            //--------------------------------------------------------------//                
            if(PositionGetInteger(POSITION_TYPE)==0) //type=BUY
              {
                double LastPrice = Ask;
                if(barLow3<barLow2 && barLow3<barLow1 && CurrentStopLoss!=barLow3)
                  {
                    iTrade.PositionModify(PositionTicket,barLow3,CurrentTakeProfit);
                  }
              }
            //--------------------------------------------------------------//      
            else if(PositionGetInteger(POSITION_TYPE)==1) //type=SELL
              {
                double LastPrice = Bid;
                if(barHigh3>barHigh2 && barHigh3>barHigh1 && CurrentStopLoss!=barHigh3)
                  {
                    iTrade.PositionModify(PositionTicket,barHigh3,CurrentTakeProfit);
                  }                             
              } 
          } 
      }
  }
