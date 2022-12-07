//
//  FilesViewController.swift
//  Assessment
//
//  Created by deepthi reddy on 06/12/22.
//

import UIKit
import BSImagePicker
import Photos
import KDDragAndDropCollectionViews
class FilesViewController: UIViewController,KDDragAndDropCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    
    @IBOutlet weak var imagesCollectionView: KDDragAndDropCollectionView!
    @IBOutlet weak var imageview: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var imagesArray = [AnyObject]()
    private let imageManager = PHCachingImageManager()
    private let contentMode: PHImageContentMode = .aspectFill
    
    var dragAndDropManager : KDDragAndDropManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.backgroundColor = UIColor.white
        self.imagesCollectionView.register(UINib(nibName:"imagesCell" , bundle : nil), forCellWithReuseIdentifier: "imagesCell")
        
        self.dragAndDropManager = KDDragAndDropManager(
            canvas: self.view,
            collectionViews: [imagesCollectionView]
        )
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        
        var imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 10
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.selection.unselectOnReachingMax = true

        let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
            
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            self.imagesArray = assets;
            
            
            DispatchQueue.main.async {
                
                self.imagesCollectionView.reloadData();
            }
            
            let album = assets[0]
            var imageSize: CGSize = .zero {
                didSet {
                    self.imageManager.stopCachingImagesForAllAssets()
                }
            }
           
        var test =  self.imageManager.requestImage(for: album, targetSize: imageSize, contentMode: self.contentMode, options: nil) { (image, _) in
                guard let image = image else { return }
               self.imageview.image = image
            }
            
            
           
        }, completion: {
            let finish = Date()
            print(finish.timeIntervalSince(start))
        })
        
    }
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to: IndexPath) {
        
        let fromDataItem = imagesArray[from.item]
        imagesArray.remove(at: from.item)
        imagesArray.insert(fromDataItem, at: to.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return self.imagesArray[indexPath.item]
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
        
        let dataItem = imagesArray[indexPath.item]
        var imageSize: CGSize = .zero {
            didSet {
                self.imageManager.stopCachingImagesForAllAssets()
            }
        }
        let test =  self.imageManager.requestImage(for: dataItem as! PHAsset, targetSize: imageSize, contentMode: self.contentMode, options: nil) { (image, _) in
            guard let image = image else { return }
           cell.imageview.image = image
        }
       
        
        cell.isHidden = false
        
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
            
            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                
                if draggingPathOfCellBeingDragged.item == indexPath.item {
                    
                    cell.isHidden = true
                    
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        guard let candidate = dataItem as? AnyObject else { return nil }
        
        for (i,item) in self.imagesArray.enumerated() {
            
            //var item = AnyO
            if candidate !== item  { continue }
            return IndexPath(item: i, section: 0)
        }
        
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {
        self.imagesArray.remove(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
        
        if let di = dataItem as? AnyObject {
            self.imagesArray.insert(di, at: indexPath.item)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width:150, height: 150)
      
        
        
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
