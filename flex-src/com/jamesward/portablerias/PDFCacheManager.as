package com.jamesward.portablerias
{
import flash.external.ExternalInterface;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.events.EventDispatcher;

import mx.core.Application;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ObjectUtil;

[Event(name="fault", type="mx.rpc.events.FaultEvent")]

public class PDFCacheManager extends EventDispatcher
{

  private var srv:HTTPService;
  private var readerVersion:Number;
  
  [Bindable]
  public var inPDF:Boolean = false;
  
  [Bindable]
  public var lastResult:Object;
  
  [Bindable]
  public var lastXMLResult:String;
  
  [Bindable]
  public var inBrowser:Boolean = false;
  
  public function PDFCacheManager()
  {
    super();

    srv = new HTTPService();
    srv.useProxy = false;
    // force the result to be text
    srv.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
    srv.addEventListener(ResultEvent.RESULT, handleResult);
    srv.addEventListener(FaultEvent.FAULT, handleFault);

    try
    {
      ExternalInterface.call("eval", "function getViewerVersion() { return app.viewerVersion }");
      var r:Object = ExternalInterface.call("getViewerVersion");
      if (r != null)
      {
        readerVersion = new Number(r);
      }
      
      if (readerVersion > 0)
      {
        inPDF = true;
      }
      
      if (readerVersion < 9)
      {
        // Alert.show("You must use Adobe Acrobat 9 or Adobe Reader 9 to view this PDF");
      }
    }
    catch (e:Error)
    {
      // not in a PDF
    }
    
    if (readerVersion >= 9)
    {
      // setup function to get the data from the PDF
      ExternalInterface.call("eval", "function getData() { return xfa.form.PortableRIAs.dataScript.getData(); }");
      
      // setup function to set the data in the PDF
      ExternalInterface.call("eval", "function setData(dataString) { xfa.form.PortableRIAs.dataScript.setData(dataString); }");
      
      // see if the PDF has been opened in the browser or in Reader
      ExternalInterface.call("eval", "function getExternal() { return this.external; }");
      inBrowser = ExternalInterface.call("getExternal");
    }
    
  }
  
  public function set url(_url:String):void
  {
    srv.url = _url;
  }
  
  private function handleResult(event:ResultEvent):void
  {
    parseData(event.result as String);
      
    if (inPDF)
	  {
	    updateCache();
	  }
  }
  
  private function parseData(dataString:String):void
  {
    lastXMLResult = dataString;
      
	  var xn:XMLNode = XMLNode(new XMLDocument(lastXMLResult));
	  lastResult = (new SimpleXMLDecoder(true)).decodeXML(xn);
  }
  
  private function handleFault(event:FaultEvent):void
  {
    dispatchEvent(event);
  }
  
  public function getDataFromServer():void
  {
    srv.send();
  }
  
  public function getDataFromCache():void
  {
    var xmlDataString:String = ExternalInterface.call("getData");
		  
	  parseData(xmlDataString);
  }
  
  private function updateCache():void
  {
    ExternalInterface.call("setData", lastXMLResult);
  }

}
}