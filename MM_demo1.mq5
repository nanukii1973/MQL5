#include <Nanukii\nObject.mqh>
//#include <ChartObjects\ChartObjectsShapes.mqh>
//#include <ChartObjects\ChartObjectsTxtControls.mqh>
#include <Indicators\TimeSeries.mqh>
#include <Math\Stat\Normal.mqh>
#include <Controls\Button.mqh>
CiHigh          High;
CiOpen          Open;
CiClose        Close;
CiLow            Low;
CButton  B1, B2, B3;
//CiATR          Atr12;

//CChartObjectRectangle R1;
//CChartObject C1;
//string Rect="Rect_";

int ZBar;
string bottonClick="";
string lineH="";
//----------------------------------//
int OnInit()
  {
   HLineCreate(0,"Hline_SL",0,0,clrNONE,STYLE_DASH,1,0,0,0,0);
   HLineCreate(0,"Hline_TP",0,0,clrNONE,STYLE_DASH,1,0,0,0,0);  
  
    RectLabelCreate(0,"Rect",0,10,80,200,300,clrBlack,BORDER_FLAT,CORNER_LEFT_UPPER,clrLimeGreen,STYLE_SOLID,0,0,0,1,0);
    RectLabelCreate(0,"Rect1",0,15,130,190,240,clrNONE,BORDER_FLAT,CORNER_LEFT_UPPER,clrGray,STYLE_SOLID,1,0,0,1,0);
    RectLabelCreate(0,"Rect2",0,20,185,180,50,clrNONE,BORDER_FLAT,CORNER_LEFT_UPPER,clrGray,STYLE_SOLID,1,0,0,1,0);
   //BitmapCreate(0,"PNG",0,0,0,"",10,10,0,0,clrRed,STYLE_SOLID,1,0,0,0,0);
   //BitmapSetImage(0,"PNG","\\Experts\\Nanakii\\JPG.bmp");
    LabelCreate(0,"Label1",0,30,90,CORNER_LEFT_UPPER,"BID","Arial Bold",12,clrLimeGreen,0,0,0,0,ALIGN_CENTER);
    LabelCreate(0,"Label2",0,95,87,CORNER_LEFT_UPPER,"spred","Arial",10,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    LabelCreate(0,"Label3",0,160,90,CORNER_LEFT_UPPER,"ASK","Arial Bold",12,clrOrangeRed,0,0,0,0,ALIGN_CENTER);
    
    LabelCreate(0,"Text1",0,22,110,CORNER_LEFT_UPPER,"0","Arial Bold",10,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    LabelCreate(0,"Text2",0,105,105,0,"0","Arial Bold",16,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    ObjectSetInteger(0,"Text2",OBJPROP_ANCHOR,ANCHOR_LEFT,0);
    LabelCreate(0,"Text3",0,150,110,CORNER_LEFT_UPPER,"0","Arial Bold",10,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    
    LabelCreate(0,"Label4",0,30,140,CORNER_LEFT_UPPER,"LOT","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);   
    LabelCreate(0,"Text4",0,150,140,CORNER_LEFT_UPPER,"0.01","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);

    LabelCreate(0,"Label5",0,30,160,CORNER_LEFT_UPPER,"RiSK%","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);    
    LabelCreate(0,"Text5",0,150,160,CORNER_LEFT_UPPER,1.0+"%","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_RIGHT);
    //----------------------------------------------------------------------------------------------------------//    
    LabelCreate(0,"Label6",0,30,190,CORNER_LEFT_UPPER,"StopLoss","Arial Bold",10,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    LabelCreate(0,"Text_SL",0,130,190,CORNER_LEFT_UPPER,"0.0","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);   
    LabelCreate(0,"Text6",0,175,190,CORNER_LEFT_UPPER,"pip","Arial",8,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);

    LabelCreate(0,"Label7",0,30,210,CORNER_LEFT_UPPER,"TakeProfit","Arial Bold",10,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);    
    LabelCreate(0,"Text_TP",0,130,210,CORNER_LEFT_UPPER,"0.0","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    LabelCreate(0,"Text7",0,175,210,CORNER_LEFT_UPPER,"pip","Arial",8,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    //--------------------------------------------------------------------------------------------------------//
    LabelCreate(0,"Label8",0,30,240,CORNER_LEFT_UPPER,"Reward Ratio","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);    
    LabelCreate(0,"Text8",0,180,240,CORNER_LEFT_UPPER,"%","Arial Bold",12,clrWhiteSmoke,0,0,0,0,ALIGN_CENTER);
    
    B1.Create(0,"Button_buy",0,0,0,70,40); B1.Shift(20,320);
    //B1.Create(0,"",0,)
    B1.Text("BUY"); B1.Font("Arial Bold"); B1.FontSize(12); B1.Color(clrLimeGreen); B1.ColorBackground(clrDimGray);
    
    B2.Create(0,"Button_sell",0,0,0,60,40); B2.Shift(140,320);
    B2.Text("SELL"); B2.Font("Arial Bold"); B2.FontSize(12); B2.Color(clrOrangeRed); B2.ColorBackground(clrDimGray);
    
    B3.Create(0,"Button1",0,0,0,30,40); B3.ColorBackground(clrDimGray); B3.Text("!"); B3.FontSize(12);
    B3.Color(clrWhiteSmoke); B3.Shift(100,320);
    //ButtonCreate(0,"Button1",0,100,325,20,40,CORNER_LEFT_UPPER,"!","Arial Bold",12,clrWhite,clrBlack,clrNONE);
    
    //ButtonCreate(0,"Button_buy",0,20,325,80,40,CORNER_LEFT_UPPER,"BUY","Arial Bold",12,clrLimeGreen,clrBlack,clrNONE);
    //ButtonCreate(0,"Button_sell",0,120,325,80,40,CORNER_LEFT_UPPER,"SELL","Arial Bold",12,clrOrangeRed,clrBlack,clrNONE);
    EditCreate(0,"Edit1",0,150,240,30,18,"1.5","Arial Bold",11,ALIGN_LEFT,0,CORNER_LEFT_UPPER,clrWhiteSmoke,clrNONE);
    //------------------------------------------------------------------------------------------------------------//
        
    //------------------------------------------------------------------------------------------------------------//
   High.Create(_Symbol,PERIOD_CURRENT);
   Open.Create(_Symbol,PERIOD_CURRENT);
   Close.Create(_Symbol,PERIOD_CURRENT);
   Low.Create(_Symbol,PERIOD_CURRENT);    
   //-------------------------------------------------------------------------------------------------------------//

   
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   
    //EventSetTimer(1);
    //ChartRedraw();
   
   return(INIT_SUCCEEDED);
  }
//----------------------------------//
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,"Label",0);
   ObjectsDeleteAll(0,"Text",0);
   ObjectsDeleteAll(0,"Rect",0);
   ObjectsDeleteAll(0,"Button",0);  
   ObjectsDeleteAll(0,"Edit",0);
   ObjectsDeleteAll(0,"Hline",0);
   
   B1.Destroy(reason);
   B2.Destroy(reason);
   B3.Destroy(reason);
   High.Delete(reason);
   Open.Delete(reason);
   Close.Delete(reason);
   Low.Delete(reason);
  }
//----------------------------------//
void OnTick()
  {
      High.Refresh();
      Open.Refresh();
      Close.Refresh();
      Low.Refresh();  
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   //float spred=SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)*_Point;
   int spred=SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);
   
   ObjectSetString(0,"Text1",OBJPROP_TEXT,Bid);
   ObjectSetString(0,"Text3",OBJPROP_TEXT,Ask);
   ObjectSetString(0,"Text2",OBJPROP_TEXT,spred);
   
   double RR=StringToDouble(ObjectGetString(0,"Edit1",OBJPROP_TEXT,0));
   int ADR=iADR(6)/_Point;
   int ADRTP=ADR*RR;
 
   ObjectSetString(0,"Text_SL",OBJPROP_TEXT,ADR);
   ObjectSetString(0,"Text_TP",OBJPROP_TEXT,ADRTP);
   //ObjectSetInteger(0,"Button1",OBJPROP_STATE);
   
   double lineSL=(StringToDouble(ObjectGetString(0,"Text_SL",OBJPROP_TEXT,0)))*_Point;
   double lineTP=(StringToDouble(ObjectGetString(0,"Text_TP",OBJPROP_TEXT,0)))*_Point;

   if(MQLInfoInteger(MQL_VISUAL_MODE)==true)
     {
      
     
    
   if(FileIsExist("buy.txt",FILE_COMMON))
     {

      FileDelete("sell.txt",FILE_COMMON);
      FileDelete("buy.txt",FILE_COMMON);
      FileDelete("b1.txt",FILE_COMMON);
      FileDelete("b2.txt",FILE_COMMON);
      
      bottonClick="buyClick";
         //Comment("BUY");
         //ObjectSetInteger(0,"Button_sell",OBJPROP_STATE,false);     
     }      
   if(FileIsExist("sell.txt",FILE_COMMON))
     {

      FileDelete("sell.txt",FILE_COMMON);
      FileDelete("buy.txt",FILE_COMMON);
      FileDelete("b1.txt",FILE_COMMON);
      FileDelete("b2.txt",FILE_COMMON);
      
      bottonClick="sellClick";
         //Comment("BUY");
         //ObjectSetInteger(0,"Button_sell",OBJPROP_STATE,false);     
     }
   if(FileIsExist("b1.txt",FILE_COMMON))
     {

      FileDelete("sell.txt",FILE_COMMON);
      FileDelete("buy.txt",FILE_COMMON);
      FileDelete("b1.txt",FILE_COMMON);
      FileDelete("b2.txt",FILE_COMMON);
      
      ObjectSetInteger(0,"Hline_SL",OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,"Hline_TP",OBJPROP_COLOR,clrNONE);
     }
   if(FileIsExist("b2.txt",FILE_COMMON))
     {

      FileDelete("sell.txt",FILE_COMMON);
      FileDelete("buy.txt",FILE_COMMON);
      FileDelete("b1.txt",FILE_COMMON);
      FileDelete("b2.txt",FILE_COMMON);
      
      ObjectSetInteger(0,"Hline_SL",OBJPROP_COLOR,clrOrangeRed);
      ObjectSetInteger(0,"Hline_TP",OBJPROP_COLOR,clrLimeGreen);
       }     
     
   }

 
 
   if(bottonClick=="buyClick")
     {
        HLineMove(0,"Hline_SL",Ask-lineSL);
        HLineMove(0,"Hline_TP",Ask+lineTP);   
     }
   if(bottonClick=="sellClick")
     {
        HLineMove(0,"Hline_SL",Bid+lineSL);
        HLineMove(0,"Hline_TP",Bid-lineTP);   
     }
/*
   if(ObjectGetInteger(0,"Button1",OBJPROP_STATE)==1)
     {
      ObjectSetInteger(0,"Hline_SL",OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,"Hline_TP",OBJPROP_COLOR,clrNONE);
      //ChartRedraw();
     }
    if(ObjectGetInteger(0,"Button1",OBJPROP_STATE)==0)
     {
      ObjectSetInteger(0,"Hline_SL",OBJPROP_COLOR,clrOrangeRed);
      ObjectSetInteger(0,"Hline_TP",OBJPROP_COLOR,clrLimeGreen);
     } */
  }
//----------------------------------//

//----------------------------------//
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
  {
   //if(id==CHARTEVENT_CLICK)
   //  {
   //   Print("The coordinates of the mouse click on the chart are: x = ",lparam,"  y = ",dparam);
   //  }

//--- the mouse has been clicked on the graphic object

   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Button_buy")
     {
     
         bottonClick="buyClick";
         Comment("BUY");
         ObjectSetInteger(0,"Button_sell",OBJPROP_STATE,false);

        }
      if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Button_sell")
        {
         bottonClick="sellClick";
         Comment("SELL");
         ObjectSetInteger(0,"Button_buy",OBJPROP_STATE,false);
         
        }
      if(sparam=="Button1")
        {
         //bottonClick="LineClick";
       
         //printf(id+" - "+lparam+" - "+dparam+" - "+sparam+" - ");
        }              
      //Print("The mouse has been clicked on the object with name '"+sparam+"'");
     }

  
  
//----------------------------------//

double iADR(int period)
    { 
      double ADR=0.0;
      if(ZBar!=iBars(_Symbol,PERIOD_CURRENT))
        {
      double preADR=0.0; 
      double sumADR=0.0;
      
      
      for(int i=1;i<period;i++)
        {
         preADR=MathAbs(High.GetData(i)-Low.GetData(i));
         sumADR=sumADR+preADR;
         preADR=0;
        }
        
         ADR=NormalizeDouble((sumADR/period),_Digits);
        //Comment(sumADR,"\n",
        //        NormalizeDouble((sumADR/6),_Digits),"\n",
        //        High.GetData(1),"\n",
        //        Close.GetData(0));
        //        ADR=NormalizeDouble((sumADR/6),_Digits);
        //        ZBar=iBars(_Symbol,PERIOD_CURRENT);
         
        }
        return(ADR);
    }  
    
    
    //-----------------------
    
