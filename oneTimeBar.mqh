int barCheck=0;

void OnTick()
  {  
      int Bar=Bars(_Symbol,PERIOD_CURRENT);
      if(barCheck!=Bar)
        {
          Comment("Do Someting 1time/1bar");
          
          barCheck=Bar;          
        }
   }
