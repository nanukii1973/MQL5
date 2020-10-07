//------------------------------------------------------------------//
#include <\Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include  <Indicators\Trend.mqh>

CTrade      Trade;
//CiMA        Ema8,Ema13, Ema21;
double high[], low[], open[], close[], Ema8[], Ema13[], Ema21[];
int barCheck,barCheck0, barCheck1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {   
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(Ema8, true);
   ArraySetAsSeries(Ema13, true);
   ArraySetAsSeries(Ema21, true);

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
   CopyHigh(_Symbol,PERIOD_CURRENT,0,8,high);
   CopyLow(_Symbol,PERIOD_CURRENT,0,8,low);
   CopyOpen(_Symbol,PERIOD_CURRENT,0,8,open);
   CopyClose(_Symbol,PERIOD_CURRENT,0,8,close);
   int Ema8Def=iMA(_Symbol,PERIOD_CURRENT,8,0,MODE_EMA,PRICE_CLOSE);
   int Ema13Def=iMA(_Symbol,PERIOD_CURRENT,13,0,MODE_EMA,PRICE_CLOSE);
   int Ema21Def=iMA(_Symbol,PERIOD_CURRENT,21,0,MODE_EMA,PRICE_CLOSE);
   
   CopyBuffer(Ema8Def,0,0,8,Ema8);
   CopyBuffer(Ema13Def,0,0,13,Ema13);
   CopyBuffer(Ema21Def,0,0,21,Ema21);

   double SL, pos;
   double Ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double Bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   int bar=iBars(_Symbol,PERIOD_CURRENT);
   
   //---signal
   string signal="";
   if(barCheck0!=bar)
     {

        if(Ema8[1]>Ema13[1] && Ema13[1]>Ema21[1]
         && low[1]<Ema8[1] && low[2]>Ema8[2])
          {
           signal="BUY";
          }
         
       if(Ema8[1]<Ema13[1] && Ema13[1]<Ema21[1]
         && high[1]>Ema8[1] && high[2]<Ema8[2])
         {
          signal="SELL";
         }
        
     }
   if(PositionsTotal()<1)
     {
     if(barCheck!=bar)
     {     
      if(signal=="BUY")
        {
         int Total=OrdersTotal();
         if(Total!=0)
            {
             ulong ticket=OrderGetTicket(0);
             string TypeOrder=(OrderGetInteger(ORDER_TYPE));
             for(int i=0;i<Total;i++)
                  {
                  if((ticket=OrderGetTicket(i))>0)
                    {
                     if(TypeOrder==ORDER_TYPE_BUY_STOP) Trade.OrderDelete(ticket);
                     if(TypeOrder==ORDER_TYPE_SELL_STOP) Trade.OrderDelete(ticket);
                    }                      
                  }                
                } 
                SL=low[ArrayMinimum(low,1,6)];
                pos=high[ArrayMaximum(high,1,6)];                
                Trade.BuyStop(0.01,pos,NULL,pos-50*_Point,pos+(50*_Point),ORDER_TIME_DAY,0,NULL); 
                barCheck=bar;
                signal="";            
             }            
           }
         }    
   if(barCheck1!=bar)
     { 
      if(signal=="SELL")
        {      
         int Total=OrdersTotal();
         if(Total!=0)
            {
             ulong ticket=OrderGetTicket(0);
             string TypeOrder=(OrderGetInteger(ORDER_TYPE));

               for(int i=0;i<Total;i++)
                  {
                  if((ticket=OrderGetTicket(i))>0)
                    {
                     if(TypeOrder==ORDER_TYPE_BUY_STOP) Trade.OrderDelete(ticket);
                     if(TypeOrder==ORDER_TYPE_SELL_STOP) Trade.OrderDelete(ticket);
                    }                      
                  }                
                }
                 SL=high[ArrayMaximum(high,1,6)];
                 pos=low[ArrayMinimum(low,1,6)]; 
                 barCheck1=bar; 
                 Trade.SellStop(0.01,pos,NULL,pos+(50*_Point),pos-(50*_Point),ORDER_TIME_DAY,0,NULL); 
                 signal="";                          
             }          
        }  
    }
  
//+------------------------------------------------------------------+
