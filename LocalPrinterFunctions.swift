//
//  LocalPrinterFunctions.swift
//  MyBotler
//
//  Created by Joachim Dittman on 07/10/2016.
//  Copyright © 2016 Joachim Dittman. All rights reserved.
//


import Foundation

var portName : NSString = ""
var portSettings : NSString = ""
var drawerPortName : NSString = ""

var arrayPort : NSArray = ["Standard"]
var arrayFunction : NSArray = ["Sample Receipt"]
var arraySensorActive : NSArray = ["Hight"]
var arraySensorActivePickerContents : NSArray = ["High When Drawer Open"]

var selectedPort : NSInteger = 0
var selectedSensorActive : NSInteger = 0

var foundPrinters : NSArray = []
var lastSelectedPortName : NSString = ""
var p_portName : NSString = ""
var p_portSettings : NSString = ""


func setupPrinter()  {
    
    DispatchQueue.global(qos: .background).async {
        print("This is run on the background queue")
      
    foundPrinters = SMPort.searchPrinter("BT:") as NSArray
        var string = ""
        for i in foundPrinters
        {
            let portInfo : PortInfo = i as! PortInfo
            string += "\(portInfo.portName),"
        }
    
     
        
    if foundPrinters.count > 0 {
        
        print(foundPrinters.count)
        let portInfo : PortInfo = foundPrinters.object(at: 0) as! PortInfo
        print(portInfo)
        lastSelectedPortName = portInfo.portName as NSString
        print(lastSelectedPortName)
        portName = portInfo.portName as NSString
        portSettings = arrayPort.object(at: 0) as! NSString
           UXfunctions().showNot("\(foundPrinters.object(at: 0))", theme: 0, forever: 0, button: "ok")
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            
        }
    }
    else { // No hay ninguna impresora conectada
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            
        }
    }
        
       
    }
}


// Print your ticket
func printCostumerOrder(parametro : [String : AnyObject], count:Int,standardPort:String) -> Bool {
 
    print("PrintConsumerOrder")
    let commands = NSMutableData()
    var str : String
    var datos : Data?
    
    var cmd : [UInt8]
    
    
    //Spanish character set
    cmd = [ 0x1b, 0x1d, 0x74, 0x01]
    // commands.appendBytes(cmd, length: 4)
    
    // Text width
    cmd = [ 0x1b, 0x57, 0x03 ]
    commands.append(cmd, length: 3)
    
    
    // Text centered
    cmd = [ 0x1b, 0x1d, 0x61, 0x01 ]
    commands.append(cmd, length: 4)
    
    // Inversion = no
    cmd = [ 0x1b, 0x35 ]
    commands.append(cmd, length: 2)
    
    
    // medium size
    cmd = [0x1b, 0x57, 0x01]
    commands.append(cmd, length: 3)
    
    let date : String = parametro["date"] as! String
    let id : String = parametro["id"] as! String
    
    str = "\r\n \(date)\r\n \(id)\r\n"
    
    
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!)
    
    // small size
    cmd = [0x1b, 0x57, 0x00]
    commands.append(cmd, length: 3)
    str = " \r\n------------------------------------------------\r\n"
    let b : String = parametro["items"] as! String
    cmd = [0x1b,0x1d,0x61,0x00]
    commands.append(cmd, length: 4)
    let comment : String = parametro["comment"] as! String
    str += b + "\r\n"
    str += "------------------------------------------------\r\n\(comment)\r\n\r\n"
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!) 
    
    print("2")
    print(parametro)
    // medium size
    cmd = [0x1b, 0x57, 0x01]
    commands.append(cmd, length: 3)
    
    cmd = [0x1b,0x1d,0x61,0x00]
    commands.append(cmd, length: 4)
    
    let table : String = parametro["table"] as! String
    str = "Bord:\(table)\r\n"
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!)
    let costumer : Array = parametro["costumerName"]!.components(separatedBy: " ")
    str = "Kunde:\(costumer[0])\r\n"
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!)
  
    cmd = [ 0x1b, 0x64, 0x02 ] // Cut the paper
    commands.append(cmd, length: 3)
    print("print5")
    
    if(count == 1)
    {
        if(foundPrinters.count > 0)
        {
            let _ =  sendCommand(commands as Data,portName:portName, portSettings:portSettings,timeoutMillis: 10000)
        }
    }
    else
    {
        var printers = ""
    for i in foundPrinters
    {
        let portInfo : PortInfo = i as! PortInfo
        let _ =  sendCommand(commands as Data,portName:portName, portSettings:portSettings,timeoutMillis: 10000)
        print(portInfo.macAddress)
        print(portInfo.modelName)
        printers += portInfo.portName
        print(portInfo.portName)
    }
        UXfunctions().showNot(printers, theme: 0, forever: 0, button: "ok")
    }
    return true
}

// Print your ticket
func Printitems(items : String, totalPrice:String,tip:String, date:String, count:Int,standardPort:String) -> Bool {
    print("1")
    let commands = NSMutableData()
    var str : String
    var datos : Data?
    
    var cmd : [UInt8]
    
    
    //Spanish character set
    cmd = [ 0x1b, 0x1d, 0x74, 0x01]
    // commands.appendBytes(cmd, length: 4)
    
    // Text width
    cmd = [ 0x1b, 0x57, 0x03 ]
    commands.append(cmd, length: 3)
    
    
    // Text centered
    cmd = [ 0x1b, 0x1d, 0x61, 0x01 ]
    commands.append(cmd, length: 4)
    
    // Inversion = no
    cmd = [ 0x1b, 0x35 ]
    commands.append(cmd, length: 2)
    
    
    
    
    // small size
    cmd = [0x1b, 0x57, 0x00]
    commands.append(cmd, length: 3)
    
    str = "\r\n rapport\r\n  "
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!)
    str = "Total:\(totalPrice)\r\n Tip:\(tip)\r\n  "
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!)
    
    str = "----------------------------------------------\r\n"
    cmd = [0x1b,0x1d,0x61,0x00]
    commands.append(cmd, length: 4)
    str += items + "\r\n\r\n\(date)"
    datos = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
    commands.append(datos!)
    
    
    
    cmd = [ 0x1b, 0x64, 0x02 ] // Cut the paper
    commands.append(cmd, length: 3)
    if(count == 1)
    {
        if(foundPrinters.count > 0)
        {
            let _ =  sendCommand(commands as Data,portName:portName, portSettings:portSettings,timeoutMillis: 10000)
        }
    }
    else
    {
        for i in foundPrinters
        {
            let portInfo : PortInfo = i as! PortInfo
            let _ =  sendCommand(commands as Data,portName:portName, portSettings:portSettings,timeoutMillis: 10000)
            print(portInfo.macAddress)
            print(portInfo.modelName)
            print(portInfo.portName)
        }
    }
    return true
}

func sendCommand(_ commandsToPrint : Data, portName : NSString, portSettings: NSString, timeoutMillis : u_int) -> Bool{
    
    let commandSize : Int = commandsToPrint.count as Int
    var dataToSentToPrinter = [CUnsignedChar](repeating: 0, count: commandsToPrint.count)
     
    (commandsToPrint as NSData).getBytes(&dataToSentToPrinter, length: commandsToPrint.count)
    if let starPort = SMPort.getPort(portName as String, portSettings as String, timeoutMillis) {
        
        var status : StarPrinterStatus_2? = nil
        starPort.beginCheckedBlock(&status, 2)
        
        if status?.offline == 1 { 
            return false
        }
        
        var endTime : timeval = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&endTime, nil)
        endTime.tv_sec += 30
        
        //println("commandSize : \(commandSize). dataToSEntToPrinter: \(dataToSentToPrinter)")
        var totalAmountWritten : Int = 0
        while (Int(totalAmountWritten) < commandSize) {
            let remaining : Int  = Int(UInt32(commandSize) - UInt32(totalAmountWritten))
            let amountWritten : UInt32 = starPort.write(dataToSentToPrinter, UInt32(totalAmountWritten),UInt32(remaining))
            totalAmountWritten = Int(totalAmountWritten) + Int(amountWritten)
            
            var now : timeval = timeval(tv_sec: 0, tv_usec: 0)
            gettimeofday(&now, nil)
            if (now.tv_sec > endTime.tv_sec) {
                break
            }
            // starPort.endCheckedBlockTimeoutMillis = 1000
            // starPort.endCheckedBlock(&status!, 2)
            
        }
        
        if (UInt32(totalAmountWritten) < UInt32(commandSize)) {
            return false
        }
        
        starPort.endCheckedBlockTimeoutMillis = 30000
        if (status != nil) {
            starPort.endCheckedBlock(&status!, 2)
        } else {
            starPort.beginCheckedBlock(&status, 2)
            starPort.endCheckedBlock(&status, 2)
        }
        
        //free((UnsafeMutablePointer<Void>),dataToSentToPrinter)
        SMPort.release(starPort)
    } else {
        print("Error: Writte port timed out")
        
        return false
    }
    //free(dataToSentToPrinter)
    
    
    return true
}
