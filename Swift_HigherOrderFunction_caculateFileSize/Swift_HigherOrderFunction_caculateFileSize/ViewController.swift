//
//  ViewController.swift
//  Swift_HigherOrderFunction_caculateFileSize
//
//  Created by lidong on 2018/8/22.
//  Copyright © 2018年 macbook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageNames: Array = ["绿-0@3x", "绿-1@3x", "绿-2@3x", "绿-3@3x", "绿-4@3x", "绿-5@3x", "绿-6@3x", "绿-7@3x", "绿-8@3x", "绿-9@3x"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    
    @IBAction func writeFileBtnPress(_ sender: UIButton) {
        
        //存储图片的文件夹
        let logPath = self.getFilePath(fileName: "log")
        
        //判断新建文件夹
        if !FileManager.default.fileExists(atPath: logPath) {
            
            try! FileManager.default.createDirectory(atPath: logPath, withIntermediateDirectories: true, attributes: nil)
            
        }
        
        for imageName in imageNames {
            
            let imageFilePath = Bundle.main.path(forResource: imageName, ofType: ".png")
            
            let image = UIImage(contentsOfFile: imageFilePath!)
            
            let imageData = UIImagePNGRepresentation(image!)! as NSData
            
            let imageSavedFilePath = self.getFilePath(fileName: "log/\(imageName).png")
            
            let saveResult = imageData.write(toFile: imageSavedFilePath, atomically: true)
            
            print("\(imageName) is saved \(saveResult)")
            
        }
        
    }
    
    @IBAction func caculateFileBtnPress(_ sender: UIButton) {
        
        //沙盒log文件夹
        let logFolderPath = self.getFilePath(fileName: "log")
        
        //文件内的所有文件
        let childFiles = FileManager.default.subpaths(atPath: logFolderPath)
        
//        //完整写法
//        let result = childFiles?.filter({ (element) -> Bool in
//            return element.components(separatedBy: ".").last == "png"
//        }).map({ (element) -> UInt64 in
//            let filePath = logFolderPath + "/" + element
//            return self.caculateFileSize(filePath: filePath)
//        }).reduce(0, { (size, size1) -> UInt64 in
//            return size + size1
//        })
        
        //简洁写法
        let result = childFiles?.filter{
            return $0.components(separatedBy: ".").last == "png"
        }.map({ (fileName) -> UInt64 in
            let filePath = logFolderPath + "/" + fileName
            return self.caculateFileSize(filePath: filePath)
        }).reduce(0){
            $0 + $1
        }
        
        print(result!)
    }
    
    /**
     *  获得文件/文件夹位置
     */
    func getFilePath(fileName: String) -> String {
        
        let filePath: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        return filePath.appendingPathComponent(fileName)
    }
    
    /**
     *  计算文件的大小
     */
    func caculateFileSize(filePath: String) -> UInt64 {
        let fileMamager = FileManager.default
        let dic: NSDictionary = try! fileMamager.attributesOfItem(atPath: filePath) as NSDictionary
        let size = dic.fileSize()
        return size
    }
    
}

