//
//  NewsViewController.swift
//  Assessment
//
//  Created by deepthi reddy on 06/12/22.
//

import UIKit

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!
    
    var newsArray = [NewsItems]();
    
    var nextOffset = 0
    private lazy var loaderMoreView: UIView = {
        let loaderView = UIActivityIndicatorView(style: .whiteLarge)
        loaderView.color = UIColor.gray
        loaderView.startAnimating()
        return loaderView
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTableView.register(UINib(nibName:"NewsTableViewCell" , bundle : nil), forCellReuseIdentifier: "NewsTableViewCell")
       
        getRequest();
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCount = self.newsArray.count
        if indexPath.row == (currentCount-1) { //last row
            self.addData()
            self.setUpLoaderView(toShow: true)
        } else {
            self.setUpLoaderView(toShow: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath)as! NewsTableViewCell
       
        
        cell.selectionStyle = .none
        
      
        

        if(newsArray[indexPath.row].url == nil){
            print("url is empty");
        }else{
            let url = URL(string: newsArray[indexPath.row].url!)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    cell.imageview.image = UIImage(data: data!)
                }
            }
        }

       
        cell.contentLabel.text = newsArray[indexPath.row].content
        
        cell.createdDateLabel.text = newsArray[indexPath.row].title
        
        
        
        //  cell.collection.reloadData()
        
        
        return cell
    }
    func getRequest() {
        
        // request url
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=f341b8c7dd5044fbbd37758003f7d774")! // change the url
        
        // create URLSession with default configuration
        let session = URLSession.shared
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("GET Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Invalid Response received from the server")
                      return
                  }
            
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                // serialise the data object into Dictionary [String : Any]
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String:AnyObject] {
                    print(jsonResponse);
                    
                    
                    
                    let articles = jsonResponse["articles"] as! Array<AnyObject>
                    
                    for obj in articles {
                        
//                        var url = String();
//                        var content = String();
                        
                        var url = obj["urlToImage"]
                        var content = obj["description"]
                        var title = obj["title"]
                        
                        
                        if(content != nil){
                            content = obj["description"]
                        }else{
                            content = "";
                        }
                        
                        if(url != nil){
                            url = obj["urlToImage"]
                        }else{
                            url = "";
                        }
                        
                        if(title != nil){
                            title = obj["title"]
                        }else{
                            title = "";
                        }
                        
                        
                       
                        
                        
                        
                       
                        
                        
                       
                        let news = NewsItems(url: url as? String, content: content as? String,title: title as? String);
                        
                        
                        self.newsArray.append(news);
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                   
                    
                    
                    
                    print(self.newsArray);
                    
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                    }
                    
                    
                   
                    
                } else {
                    print("data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print("JSON Parsing Error: \(error.localizedDescription)")
            }
        }
        // resume the task
        task.resume()
    }
    func addData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.addElements()
            self.newsTableView.reloadData()
        }
    }
    func addElements() {
        nextOffset = 0;
        let newOffset = nextOffset+newsArray.count
        for i in nextOffset..<newOffset {
            newsArray.append(newsArray[i])
        }
        nextOffset = newOffset
    }
    func setUpLoaderView(toShow: Bool) {
        if toShow {
            self.newsTableView.tableFooterView?.isHidden = false
            self.newsTableView.tableFooterView = self.loaderMoreView
        } else {
            self.newsTableView.tableFooterView = UIView()
        }
    }

    @IBAction func fileBtnAction(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilesViewController") as! FilesViewController

      
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
