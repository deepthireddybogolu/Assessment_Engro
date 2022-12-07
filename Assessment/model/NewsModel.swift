//
//  NewsModel.swift
//  Assessment
//
//  Created by deepthi reddy on 06/12/22.
//

//import Foundation
//class NewsResponse {
//
//
//var newArray: Array<AnyObject>?
//
//init(newsItems: Array<AnyObject>?){
//
//    self.newArray = newsItems
// }
//class NewsItems {
//
//
//    var image: String?
//    var content: String?
//    var createdDate: String?
//
//
//    init(image: String?,content: String?,createdDate: String?){
//        self.image = image
//        self.content = content
//        self.createdDate = createdDate
//
//       }
//     }
//}


class NewsItems {


var url: String?
var content: String?
var title: String?


    init(url: String?,content: String?,title:String?){
    self.url = url
    self.content = content
    self.title = title
 
   }
 }
