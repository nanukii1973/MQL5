#include  <Trade\Trade.mqh>

#define  EXPERT_MAGIC_BUY 999000
#define  EXPERT_MAGIC_SELL 999111

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool closeByMagic(int magic)
  {
   int total = PositionsTotal();
   for(int i = total + 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      PositionSelectByTicket(ticket);
      if(PositionGetInteger(POSITION_MAGIC) == magic)
        {
         Trade.PositionClose(ticket);
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SandOrder(double lot = 0.01,
               ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY,
               double sl = 0.0,
               double tp = 0.0
              )
  {
   MqlTradeRequest request = {0};
   MqlTradeResult  result = {0};
   request.action = TRADE_ACTION_DEAL;
   request.symbol = Symbol();
   request.volume = lot;
   request.type   = orderType;
   request.sl     = sl;
   request.tp     = tp;
   request.price  = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   request.deviation = 5;
   request.magic  = EXPERT_MAGIC_BUY;
   if(orderType == ORDER_TYPE_SELL)
     {
      request.price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
      request.magic  = EXPERT_MAGIC_SELL;
      request.magic  = EXPERT_MAGIC_SELL;
     }
   if(!OrderSend(request, result))
      PrintFormat("OrderSand error %d", GetLastError());
   PrintFormat("retcode=%u deal=%I64u order=%I64u", result.retcode, result.deal, result.order );
   return(true);
  }

//+------------------------------------------------------------------+
