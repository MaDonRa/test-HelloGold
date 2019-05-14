//
//  ManageRequestData.swift
//  FetchData
//
//  Created by Sakkaphong Luaengvilai on 12/1/2560 BE.
//  Copyright © 2560 MaDonRa. All rights reserved.
//

import UIKit

typealias FetchRestfulAndImageDelegate = FetchRestfulDelegate & FetchGetImageDelegate

protocol FetchGetImageDelegate {
    func GetImageData(url : String , UseCacheIfHave: Bool , completion:@escaping (Data)->())
    func StartLoadingAnimation()
    func StopLoadingAnimation()
    func LoadingAnimation(completion:@escaping (Bool)->())
}

internal enum HTTPMethod : String {
    case GET , POST , DELETE , PATCH , PUT
}

protocol FetchRestfulDelegate {
    func RestfulPostDataWithJSON(url : String , Method : HTTPMethod , UseCacheIfHave: Bool , Body : [String : Any]? , Animation : Bool, completion:@escaping (ResponseEntity,ServerStatusCodeEntity)->())
    func RestfulPostFormData(url : String , Method : HTTPMethod , UseCacheIfHave: Bool , Body : [String : Any]? , Animation : Bool, completion:@escaping (ResponseEntity,ServerStatusCodeEntity)->())
}

enum FormDataContentType : String {
    case ImagePNG , ImageJpeg , PDF, MP4 , MOV , GIF
    
    var DataType : String {
        switch self {
        case .ImagePNG:
            return "image/png"
        case .ImageJpeg:
            return "image/jpeg"
        case .PDF:
            return "application/pdf"
        case .MP4:
            return "video/mp4"
        case .GIF:
            return "image/gif"
        case .MOV:
            return "video/quicktime"
        }
    }
}


class FetchModel : NSObject , FetchGetImageDelegate , FetchRestfulDelegate {
    
    private lazy var CheckFetched : [String:Int] = [:]
    
    private let MenuController = LoadingAnimationV(nibName: "LoadingAnimation", bundle: nil)
    internal var alertWindow : UIWindow?
    
    func GetImageData(url : String , UseCacheIfHave: Bool , completion:@escaping (Data)->()) {
        
        guard Reachability.isConnectedToNetwork() == true , let encoding = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let link_url = URL(string: encoding) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: link_url, cachePolicy: UseCacheIfHave ? .returnCacheDataElseLoad : .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)) { [unowned self]
                (data, response, error) -> Void in
                
                guard error == nil , (response as? HTTPURLResponse)?.statusCode == 200 , let data = data else {
                    
                    print("Check Internet Connection not return [200] : \(url) : \(error.debugDescription)")
                    guard let check = self.CheckFetched[url] , check < 3 else {
                        if self.CheckFetched[url] == nil {
                            self.CheckFetched[url] = 0
                        }
                        return
                    }
                    self.CheckFetched[url] = check + 1
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10) { self.GetImageData(url : url , UseCacheIfHave : UseCacheIfHave ,completion: completion) }
                    return
                    
                }
                
                DispatchQueue.main.async {
                    self.CheckFetched.removeValue(forKey: url)
                    return completion(data)
                }
                
            }
            
            task.resume()
        }
    }
    
    func StartLoadingAnimation() {
        if alertWindow == nil {
            alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow?.rootViewController = UIViewController()
            alertWindow?.windowLevel = UIWindow.Level.alert + 1;
            alertWindow?.makeKeyAndVisible()
            alertWindow?.rootViewController?.present(self.MenuController, animated: false, completion: nil)
            alertWindow?.isHidden = false
        } else {
            alertWindow?.isHidden = false
        }
    }
    
    func LoadingAnimation(completion:@escaping (Bool)->()) {
        return completion(!(alertWindow?.isHidden ?? false))
    }
    
    func StopLoadingAnimation() {
        alertWindow?.isHidden = true
    }
    
    func RestfulPostDataWithJSON(url : String , Method : HTTPMethod , UseCacheIfHave: Bool , Body : [String : Any]? , Animation : Bool , completion:@escaping (ResponseEntity,ServerStatusCodeEntity)->()) {
        
        guard Reachability.isConnectedToNetwork() == true  , let encoding = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let link_url = URL(string: encoding) else {
            let Code = ResponseEntity(json: ["errors" : ["Internet" : "Your internet service have problem. Please, check your connection"]])
            return completion(Code,ServerStatusCodeEntity.Check_Internet)
        }
        
        if Animation {
            if alertWindow == nil {
                alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow?.rootViewController = UIViewController()
                alertWindow?.windowLevel = UIWindow.Level.alert + 1;
                alertWindow?.makeKeyAndVisible()
                alertWindow?.rootViewController?.present(self.MenuController, animated: false, completion: nil)
                alertWindow?.isHidden = false
            } else {
                alertWindow?.isHidden = false
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let request = NSMutableURLRequest(url: link_url, cachePolicy: UseCacheIfHave ? .returnCacheDataElseLoad : .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
            request.httpMethod = Method.rawValue
            
            debugPrint("Fetch URL : \(url) \n" , "Body : \(Body ?? [:])")
            
            if let body = Body , !body.isEmpty {
                do {
                    let Body = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                    request.httpBody = Body
                } catch {
                    print(error)
                    return
                }
            }
            
            request.setValue(Cache.SelectedLanguage == ConfigOther.LanguageName.Thai.Language ? "TH" : "EN", forHTTPHeaderField: "Accept-Language")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            request.setValue("\(Cache.AccessToken)", forHTTPHeaderField: "Authorization")
            
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            let task = urlSession.dataTask(with: request as URLRequest) { [unowned self]
                (data, response, error) -> Void in
                
                defer { if Animation { OperationQueue.main.addOperation({ self.alertWindow?.isHidden = true }) } }
                
                guard error == nil , let ServerStatusCode = ServerStatusCodeEntity(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) , ServerStatusCode.rawValue <= ServerStatusCodeEntity.Internal_Server_Error.rawValue else {
                    
                    print("Check Internet Connection return [\((response as? HTTPURLResponse)?.statusCode ?? 0)] : \n \(url) \n ----- \(error.debugDescription)")
                    
                    guard let check = self.CheckFetched[url] , check < 3 else {
                        
                        let Code = ResponseEntity(json: ["errors" : ["Server Not Found (\((response as? HTTPURLResponse)?.statusCode ?? 0))" : "Troubleshoot connection problems"]])
                        
                        if self.CheckFetched[url] == nil {
                            self.CheckFetched[url] = 0
                        }
                        
                        DispatchQueue.main.async(execute: {
                            return completion(Code,ServerStatusCodeEntity.Check_Internet)
                        })
                        
                        return
                    }
                    self.CheckFetched[url] = check + 1
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10, execute: {
                        self.RestfulPostDataWithJSON(url: url , Method: Method, UseCacheIfHave: UseCacheIfHave, Body: Body , Animation : false , completion: completion)
                    })
                    return
                }
                
                
                DispatchQueue.main.async(execute: {
                    self.CheckFetched.removeValue(forKey: url)
                    self.CheckErrorCode401(status: ServerStatusCode.rawValue)
                    
                    guard let data = data , let json = ((try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String : Any]) as [String : Any]??) , let ConvertJson = json else {
                        return completion(ResponseEntity(json: ["done" : true]),ServerStatusCode)
                    }
                    debugPrint(ConvertJson)
                    
                    let Data = ResponseEntity(json: ConvertJson)
                    self.CheckErrorCode401(status: Data.Status.ServerStatus)
                    
                    return completion(Data,ServerStatusCodeEntity(rawValue: Data.Status.ServerStatus) ?? ServerStatusCode)
                })
            }
            
            task.resume()
        }
    }
    
    func RestfulPostFormData(url : String , Method : HTTPMethod , UseCacheIfHave: Bool , Body : [String : Any]? , Animation : Bool , completion:@escaping (ResponseEntity,ServerStatusCodeEntity)->()) {
        
        guard Reachability.isConnectedToNetwork() == true  , let encoding = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let link_url = URL(string: encoding) else {
            let Code = ResponseEntity(json: ["errors" : ["Internet" : "Your internet service have problem. Please, check your connection"]])
            return completion(Code,ServerStatusCodeEntity.Check_Internet)
        }
        
        if Animation {
            if alertWindow == nil {
                alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow?.rootViewController = UIViewController()
                alertWindow?.windowLevel = UIWindow.Level.alert + 1;
                alertWindow?.makeKeyAndVisible()
                alertWindow?.rootViewController?.present(self.MenuController, animated: false, completion: nil)
                alertWindow?.isHidden = false
            } else {
                alertWindow?.isHidden = false
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let request = NSMutableURLRequest(url: link_url)
            request.httpMethod = Method.rawValue
            
            debugPrint("Fetch URL : \(url) \n" , "Body : \(Body ?? [:])")
            
            let boundary = self.generateBoundaryString()
            
            var ConvertBody = NSMutableData()
            
            if let body = Body , !body.isEmpty {
                for (key,value) in body {
                    if value is NSNull {
                        
                    } else {
                        
                        ConvertBody.appendString("--\(boundary)\r\n")
                        
                        if key.contains("ContentData") , let File = value as? [String:Any] {
                            if let keyFromData = File["key"] as? String {
                                if let name = File["name"] as? String {
                                    if let data = File["data"] as? Data {
                                        if let dataType = File["type"] as? FormDataContentType {
                                            ConvertBody.appendString("Content-Disposition: form-data; name=\"\(keyFromData)\"; filename=\"\(name)\"\r\n")
                                            ConvertBody.appendString("Content-Type: \(dataType.DataType)\r\n\r\n")
                                            ConvertBody.append(data)
                                            ConvertBody.appendString("\r\n")
                                        }
                                    }
                                }
                            }
                        } else if key.contains("ContentDataArray") , let FileArray = value as? [[String:Any]] {
                            for File in FileArray {
                                if let keyFromData = File["key"] as? String {
                                    if let name = File["name"] as? String {
                                        if let data = File["data"] as? Data {
                                            if let dataType = File["type"] as? FormDataContentType {
                                                ConvertBody.appendString("Content-Disposition: form-data; name=\"\(keyFromData)\"; filename=\"\(name)\"\r\n")
                                                ConvertBody.appendString("Content-Type: \(dataType.DataType)\r\n\r\n")
                                                ConvertBody.append(data)
                                                ConvertBody.appendString("\r\n")
                                            }
                                        }
                                    }
                                }
                            }
                        } else if let DataArray = value as? [Any] {
                            var StartLoop : Bool = false
                            for Data in DataArray {
                                if !StartLoop {
                                    ConvertBody.appendString("Content-Disposition: form-data; name=\"\(key)[]\"\r\n\r\n")
                                    ConvertBody.appendString("\(Data)\r\n")
                                } else {
                                    ConvertBody.appendString("--\(boundary)\r\n")
                                    ConvertBody.appendString("Content-Disposition: form-data; name=\"\(key)[]\"\r\n\r\n")
                                    ConvertBody.appendString("\(Data)\r\n")
                                }
                                StartLoop = true
                            }
                        } else {
                            ConvertBody.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                            ConvertBody.appendString("\(value)\r\n")
                        }
                    }
                }
                ConvertBody.appendString("--\(boundary)--\r\n")
            }
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(Cache.SelectedLanguage == ConfigOther.LanguageName.Thai.Language ? "th" : "en", forHTTPHeaderField: "Accept-Language")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            request.setValue("\(Cache.AccessToken)", forHTTPHeaderField: "Authorization")
            
            let tempDir = FileManager.default.temporaryDirectory
            let Name = self.randomString(length: 10)
            let localURL = tempDir.appendingPathComponent(Name)
            try? ConvertBody.write(to: localURL)
            
            let config = URLSessionConfiguration.background(withIdentifier: Name)
            
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
            
            let task = urlSession.uploadTask(with: request as URLRequest, fromFile: localURL, completionHandler: { [unowned self] (data, response, error) in
                
                defer { if Animation { OperationQueue.main.addOperation({ self.alertWindow?.isHidden = true }) } }
                
                do {
                    try FileManager.default.removeItem(atPath: Name)
                } catch {
                    
                }
                
                guard error == nil , let ServerStatusCode = ServerStatusCodeEntity(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0) , ServerStatusCode.rawValue <= ServerStatusCodeEntity.Internal_Server_Error.rawValue else {
                    
                    print("Check Internet Connection return [\((response as? HTTPURLResponse)?.statusCode ?? 0)] : \n \(url) \n ----- \(error.debugDescription)")
                    
                    guard let check = self.CheckFetched[url] , check < 3 else {
                        
                        let Code = ResponseEntity(json: ["errors" : ["Server Not Found (\((response as? HTTPURLResponse)?.statusCode ?? 0))" : "Troubleshoot connection problems"]])
                        
                        if self.CheckFetched[url] == nil {
                            self.CheckFetched[url] = 0
                        }
                        
                        DispatchQueue.main.async(execute: {
                            return completion(Code,ServerStatusCodeEntity.Check_Internet)
                        })
                        
                        return
                    }
                    self.CheckFetched[url] = check + 1
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10, execute: {
                        self.RestfulPostFormData(url: url , Method: Method, UseCacheIfHave: UseCacheIfHave, Body: Body , Animation : false , completion: completion)
                    })
                    return
                }
                
                
                DispatchQueue.main.async(execute: {
                    self.CheckFetched.removeValue(forKey: url)
                    self.CheckErrorCode401(status: ServerStatusCode.rawValue)
                    
                    guard let data = data , let json = ((try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String : Any]) as [String : Any]??) , let ConvertJson = json else {
                        return completion(ResponseEntity(json: ["done" : true]),ServerStatusCode)
                    }
                    debugPrint(ConvertJson)
                    
                    let Data = ResponseEntity(json: ConvertJson)
                    self.CheckErrorCode401(status: Data.Status.ServerStatus)
                    
                    return completion(Data,ServerStatusCodeEntity(rawValue: Data.Status.ServerStatus) ?? ServerStatusCode)
                })
            })
            
            task.resume()
        }
    }
}

extension FetchModel {
    func CheckErrorCode401 (status : Int) {
        guard status == ServerStatusCodeEntity.Unauthorized.rawValue else { return }
        print("CheckErrorCode401 \(status)")
        DispatchQueue.main.async {
            guard !Cache.AccessToken.isEmpty else { return }
            let alertController = UIAlertController (title: "Error", message: "Session timeout.", preferredStyle: .alert)
            
            let firstAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(firstAction)
            
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertController, animated: true, completion: {
                Cache.RemoveAllCache()
            })
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}

extension FetchModel : URLSessionDataDelegate , URLSessionDelegate , URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
            && challenge.protectionSpace.serverTrust != nil
            && challenge.protectionSpace.host == Router.Domain {
            let proposedCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, proposedCredential)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
 
        print("percent \(Float(totalBytesSent) / Float(totalBytesExpectedToSend))")
    }
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8) else { return }
        append(data)
    }
}


