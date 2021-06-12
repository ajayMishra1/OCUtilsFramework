

import Foundation
import UIKit
import Alamofire
import Reachability

public class UtilityClass
{
    
    private init() {
        
    }
    
    public static func isInternetHasConnectivity() -> Bool {
        
        do {
            let flag = try Reachability().isReachable
            return flag
        }catch{
            return false
            
        }
    }
    
    public static func request(type: RequireType, data parameters: [String : Any] = [:],  success: ((_ response: Any) -> ())? = nil, errorr: ((_ response: String) -> ())? = nil) {
        
        if !UtilityClass.isInternetHasConnectivity(){
            errorr!("No Network. Please check your network and try again");
        }
        else{
            
            AF.request(type.url, method: type.httpMethod, parameters: parameters, encoding: type.encoding, headers: type.headers)
                .responseJSON { response in
                   
                    switch response.result {
                        
                    case .success(_):
                        if let dict = response.value{
                            UtilityClass.myPrint(dict)
                            if let code = response.response?.statusCode {
                                 if code == 200{
                                    if let dictt = dict as? NSDictionary{
                                        
                                        let Maindict = dictt.mutableCopy() as! NSMutableDictionary
                                        success!(Maindict)
                                        
                                        
                                    }else{
                                        success!(dict)
                                    }
                                    
                                }else{
                                    if let dict12 = dict as? NSDictionary{
      
                                        success!(dict12)
                                    }else{
                                        let dict = NSMutableDictionary()
                                        dict.setValue(code, forKey: "code")
                                        dict.setValue("ERROR_MESSAGE_GLOBAL", forKey: "message")
                                        var dict1 = NSDictionary()
                                        dict1 = dict
                                        
                                        success!(dict1)
                                    }
                                }
                            }else{
                               let dict = NSMutableDictionary()
                                dict.setValue("ERROR_MESSAGE_GLOBAL", forKey: "message")
                                var dict1 = NSDictionary()
                                dict1 = dict
                                success!(dict1)
                            }
                        }
                        break
                    case .failure(let error):
                        errorr!(error.localizedDescription)
                        break
                    }
            }
        }
    }
    // MARK:- Check Internet
    public static func getIPAddressForCellOrWireless()-> String? {
        
        let WIFI_IF : [String] = ["en0"]
        let KNOWN_WIRED_IFS : [String] = ["en2", "en3", "en4"]
        let KNOWN_CELL_IFS : [String] = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        
        var addresses : [String : String] = ["wireless":"",
                                             "wired":"",
                                             "cell":""]
        
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    let name: String = String(cString: (interface.ifa_name))
                    
                    if  (WIFI_IF.contains(name) || KNOWN_WIRED_IFS.contains(name) || KNOWN_CELL_IFS.contains(name)) {
                        
                        // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        if WIFI_IF.contains(name){
                            addresses["wireless"] =  address
                        }else if KNOWN_WIRED_IFS.contains(name){
                            addresses["wired"] =  address
                        }else if KNOWN_CELL_IFS.contains(name){
                            addresses["cell"] =  address
                        }
                    }
                    
                }
            }
        }
        freeifaddrs(ifaddr)
        
        var ipAddressString : String? = ""
        let wirelessString = addresses["wireless"]
        let wiredString = addresses["wired"]
        let cellString = addresses["cell"]
        if let wirelessString = wirelessString, wirelessString.count > 0{
            ipAddressString = wirelessString
        }else if let wiredString = wiredString, wiredString.count > 0{
            ipAddressString = wiredString
        }else if let cellString = cellString, cellString.count > 0{
            ipAddressString = cellString
        }
        return ipAddressString
    }
    
    public static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public static func string(from string:String) -> NSDictionary? {
//        let string = "[{\"form_id\":3465,\"canonical_name\":\"df_SAWERQ\",\"form_name\":\"Activity 4 with Images\",\"form_desc\":null}]"
        
        var dictonary:NSDictionary = NSDictionary()
            
        if let data = string.data(using: String.Encoding.utf8){
                
             do {
                dictonary =  try (JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] as NSDictionary?)!
                
                    if dictonary != nil
                      {
                          print("Dict:", dictonary)
                      }
                    } catch let error as NSError {
                    
                    print(error)
                 }
        }
        
        return dictonary
    }
 
    public static func SetupAttributeString(MainText: String,Range : String, type: String, color: UIColor?, size: CGFloat, fontname : String? = "Poppins-Medium") -> NSAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: MainText)
        let range1 = (MainText as NSString).range(of: Range)
        if type == "underline" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "font" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "underline" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        }else if type == "foreground color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "background color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.backgroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
        }
        return underlineAttriString
        
    }
    public static func SetupAttributeString1(MainText: String,Range : String, type: String, color: UIColor?, size: CGFloat, fontname : String? = "Poppins-Regular") -> NSAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: MainText)
        let range1 = (MainText as NSString).range(of: Range)
        if type == "underline" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "font" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "underline" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        }else if type == "foreground color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
        }
        else if type == "background color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.backgroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
        }
        return underlineAttriString
        
    }
    public static  func createDottedLine(_ view: UIView,_ width: CGFloat, _ color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [3,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: view.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        view.layer.addSublayer(caShapeLayer)
    }
    
    public static  func createDottedLineVertical(_ view: UIView,_ width: CGFloat, _ color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [3,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: view.frame.height)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        view.layer.addSublayer(caShapeLayer)
    }
    
    public static func addImageOnLabel(_ img : String) -> NSAttributedString{
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:img)
        let imageOffsetY: CGFloat = 0.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        return attachmentString
    }
        
    public static func BasicSpringAnimation(_ view : UIView, _ duration : TimeInterval? = 1 ,_ delay : TimeInterval? = 0, _ dumping : CGFloat? = 0.5, _ valocity : CGFloat? = 5){
        UIView.animate(withDuration: duration!, delay: delay!, usingSpringWithDamping: dumping!, initialSpringVelocity: valocity!, options: .curveEaseInOut, animations: {
            view.layoutIfNeeded()
            
        })
    }
    
    public static func changeImageviewColor(_ imgView:UIImageView, _ color: UIColor, _ image:UIImage)
    {
        imgView.image = image.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = color
    }
    
    public static func changeButtonColor(_ button:UIButton, _ color: UIColor, _ image:UIImage)
    {
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = color
    }
    
    public static func labelKerning(_ kern:CGFloat, _ label: UILabel){
        let attributes = [NSAttributedString.Key.kern: kern]
        let attributedString = NSAttributedString(string: label.text!, attributes: attributes)
        label.attributedText = attributedString
    }
  
//    #if DEBUG
    public static func myPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Swift.print(items[0], separator:separator, terminator: terminator)
    }
//    #endif

    public static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.font = font
        
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2 // change line spacing between paragraph like 36 or 48
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        // label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    public static func getAppInfo()->String {
           let dictionary = Bundle.main.infoDictionary!
           let version = dictionary["CFBundleShortVersionString"] as! String
           let build = dictionary["CFBundleVersion"] as! String
            print("version ",version)
            print("build ",build)
          // return version + "(" + build + ")"
            return build
       }
    
}


