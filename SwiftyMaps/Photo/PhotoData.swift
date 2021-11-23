//
//  SwiftyMaps
//
//  Created by Michael Rönnau on 09.11.21.
//

import Foundation
import UIKit

class PhotoData : Equatable, Identifiable, Codable{
    
    static func == (lhs: PhotoData, rhs: PhotoData) -> Bool {
        lhs.fileName == rhs.fileName
    }
    
    
    private enum CodingKeys: CodingKey{
        case id
        case creationDate
        case title
    }
    
    var id: UUID
    var creationDate: Date
    var title: String = ""
    
    var isNew = false
    
    var fileName : String {
        get{
            return "img_\(id)_\(creationDate.shortFileDate()).jpg"
        }
    }
    
    var filePath : String{
        get{
            return FileController.getPath(dirPath: FileController.privatePath,fileName: fileName)
        }
    }
    
    var fileURL : URL{
        get{
            return FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
        }
    }
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        title = try values.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(title, forKey: .title)
    }
    
    func getFile() -> Data?{
        let url = FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
        return FileController.readFile(url: url)
    }
    
    func saveFile(data: Data){
        if !FileController.fileExists(dirPath: FileController.privatePath, fileName: fileName){
            let url = FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
            _ = FileController.saveFile(data: data, url: url)
        }
    }
    
    func fileExists() -> Bool{
        return FileController.fileExists(dirPath: FileController.privatePath, fileName: fileName)
    }
    
    func prepareDelete(){
        if FileController.fileExists(dirPath: FileController.privatePath, fileName: fileName){
            if !FileController.deleteFile(dirURL: FileController.privateURL, fileName: fileName){
                print("error: could not delete file: \(fileName)")
            }
        }
    }
    
    func isComplete() -> Bool{
        return fileExists()
    }
    
    func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
    
    func getImage() -> UIImage?{
        if let data = getFile(){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    func saveImage(uiImage: UIImage){
        if let data = uiImage.jpegData(compressionQuality: 0.8){
            saveFile(data: data)
        }
    }
    
}

