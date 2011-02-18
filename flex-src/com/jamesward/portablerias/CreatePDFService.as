package com.jamesward.portablerias
{
  import flash.net.URLRequest;
  import flash.net.navigateToURL;
  
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.remoting.RemoteObject;
  
  public class CreatePDFService
  {
    private var ro:RemoteObject;
    
    public function CreatePDFService()
    {
      ro = new RemoteObject("PDFService");
      ro.addEventListener(ResultEvent.RESULT, handleResult);
    }
    
    public function generatePDF(xmlString:String):void
    {
      var xmlData:XML = <PortableRIAs><Data>{xmlString}</Data></PortableRIAs>;
      
      ro.generatePDF(xmlData);
    }
    
    private function handleResult(event:ResultEvent):void
    {
      var url:String = event.result as String;
      navigateToURL(new URLRequest(url), "_blank");
    }

  }
}