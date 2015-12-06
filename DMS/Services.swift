//
//  Services.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/4/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation

class Services : NSObject, NSURLConnectionDelegate, NSXMLParserDelegate{
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    var viewController:UIViewController?
    
    init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
//    , success: (result: Bool) -> Void, failure: (error: NSError, msg:NSString) -> Void
    func login(username:String, password:String){
        
        let soapMessage:NSString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><XXX_LOGIN xmlns='http://tempuri.org/'><USERNAME>900189</USERNAME><PASSWORD>123456</PASSWORD></XXX_LOGIN></soap:Body></soap:Envelope>"
        
        let urlString = "http://87.101.205.237:1257/service.asmx"
        
        let url = NSURL(string: urlString)
        
        let theRequest = NSMutableURLRequest(URL: url!)
        
        let msgLength = String(soapMessage.length)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://tempuri.org/XXX_LOGIN", forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        MBProgressHUD.showHUDAddedTo(viewController!.view, animated: true)
        let connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        if (connection == true) {
            var mutableData : Void = NSMutableData.initialize()
        }
        

    }
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        
    }
    
    
    // NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElementName = elementName
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if currentElementName == Common.LoginResult {
            
            MBProgressHUD.hideHUDForView(viewController!.view, animated: true)
            
            let containerViewController = ContainerViewController()
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            containerViewController.modalTransitionStyle = modalStyle
            viewController!.presentViewController(containerViewController, animated: true, completion: nil)
        }
    }
    
    
   
}