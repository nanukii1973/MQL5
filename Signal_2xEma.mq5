//---return ค่าเป็น string ("BUY", "SELL", "Wait Signal...!")------//
//---------------------------------------------------------------//

input int                  FastMA=20; 
input int                  SlowMA=100; 
input int                  atrPreiod=20;
input double               atrFillter=1.5; 
input ENUM_MA_METHOD       Fast_Ma_method=MODE_EMA;          
input ENUM_APPLIED_PRICE   Fast_Applied_price=PRICE_CLOSE;  
input ENUM_MA_METHOD       Slow_Ma_method=MODE_EMA;           
input ENUM_APPLIED_PRICE   Slow_Applied_price=PRICE_CLOSE; 
input double               atrTP=1.5; 
input double               atrSL=2.0;  
//----------------------------------------------------//
void OnTick()
  {   
    Comment(Signal_2xEma());
  }
//-----------------------------------------------------//
//                Signal_2xEma                         //
//-----------------------------------------------------//
int Signal_2xEma()
  {
      double maFastArray[] ,maSlowArray[], atrArray[];
      
      int maFastDef=iMA(_Symbol,PERIOD_CURRENT,FastMA,0,Fast_Ma_method,Fast_Applied_price);   
      int maSlowDef=iMA(_Symbol,PERIOD_CURRENT,SlowMA,0,Slow_Ma_method,Slow_Applied_price);
      int atrDef=iATR(_Symbol,PERIOD_CURRENT,atrPreiod);      
      
      ArraySetAsSeries(maFastArray,true);
      ArraySetAsSeries(maSlowArray,true);
      ArraySetAsSeries(atrArray,true);

      CopyBuffer(maFastDef,0,0,3,maFastArray);
      CopyBuffer(maSlowDef,0,0,3,maSlowArray);
      CopyBuffer(atrDef,0,0,3,atrArray);      
      //-------------------------------------------//      
      string signal="";      
      //-------------------------------------------//      
      double lastOpen1=iOpen(_Symbol,PERIOD_CURRENT,1);
      double lastClose1=iClose(_Symbol,PERIOD_CURRENT,1);
      double lastOpen2=iOpen(_Symbol,PERIOD_CURRENT,2);
      double lastClose2=iClose(_Symbol,PERIOD_CURRENT,2);  
          
      double lastHigh=iHigh(_Symbol,PERIOD_CURRENT,1);
      double lastLow=iLow(_Symbol,PERIOD_CURRENT,1);      
      double lastBarHigh=lastHigh-lastLow;
      //-------------------------------------------//
      if(maFastArray[1]>maSlowArray[1] && lastClose1>maFastArray[1] && lastClose1>lastOpen1 && lastClose2<maFastArray[2] && lastBarHigh<atrArray[1]*atrFillter)
         {
              signal="BUY";                                            
         }
      //-------------------------------------------//
      if(maFastArray[1]<maSlowArray[1] && lastClose1<maFastArray[1] && lastClose1<lastOpen1 && lastClose2>maFastArray[2] && lastBarHigh<atrArray[1]*atrFillter)
         {
              signal="SELL";  
         }
      if(signal!="BUY" &&signal!="SELL") signal="Wait Signal...!";
           
      return signal;
      //-------------------------------------------//
   }   
