//
//  PicsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/19/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import Photos

class PicsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PicCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var pics: [UIImage] = []
    var selectedHolder: [Int] = []
    var idea: Idea!
    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult? // Array of photos found in collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Denied {
            var alert = UIAlertController(title: "Need Permission", message: "Please go Settings > Privacy > Photos in the Settings app and grant Idealist access.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler:nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Check if folder for this idea exists. If not, create it.
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", idea.title!)
            
            // TODO: test if this loads when first asking for permission
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype:.Any, options: fetchOptions)
            if let firstObj: AnyObject = collection.firstObject {
                albumFound = true
                assetCollection = firstObj as! PHAssetCollection
            } else {
                // Create pic folder for idea
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                    let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.idea.title!)
                    }, completionHandler: { (success, error) -> Void in
                        if success {
                            println("Created new folder")
                        } else {
                            println("Photo folder creation failure.")
                        }
                        self.albumFound = success
                })
            }
            
            refreshPhotosFromCollection()
        }
    }
    
    func refreshPhotosFromCollection() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        photosAsset = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: fetchOptions)
        
        collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let photos = photosAsset {
            count = photos.count
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.frame.width / 2 - 3, self.collectionView.frame.width / 2 - 3)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! PicCell
        
        let asset: PHAsset = photosAsset![indexPath.item] as! PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(self.collectionView.frame.width / 2 - 3, self.collectionView.frame.width / 2 - 3), contentMode: PHImageContentMode.AspectFill, options: nil) { (result: UIImage!, info: [NSObject : AnyObject]!) -> Void in
            cell.picImageView.image = result
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? PicCell
        
        if let cell = cell {
            let asset: PHAsset = photosAsset![indexPath.item] as! PHAsset
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (result: UIImage!, info: [NSObject : AnyObject]!) -> Void in
                let imageInfo = JTSImageInfo()
                imageInfo.image = result
                imageInfo.referenceRect = cell.frame
                imageInfo.referenceView = cell.superview
                
                let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
                imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOriginalPosition)
            }
        }
    }
    
    func handleCheckPressed(sender: PicCell) {
        let indexPath = self.collectionView.indexPathForCell(sender)
        if let indexPath = indexPath {
            if contains(selectedHolder, indexPath.item) {
                selectedHolder.removeAtIndex(find(selectedHolder, indexPath.item)!)
                sender.checkButton.setBackgroundImage(UIImage(named: "noCheck"), forState: UIControlState.Normal)
                sender.checkButton.backgroundColor = UIColor.whiteColor()
            } else {
                selectedHolder.append(indexPath.item)
                sender.checkButton.setBackgroundImage(UIImage(named: "yesCheck"), forState: UIControlState.Normal)
                sender.checkButton.backgroundColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
            }
        }
    }

    @IBAction func sharePicsPressed(sender: UIBarButtonItem) {
        if selectedHolder.count == 0 {
            var noChecksAlert = UIAlertController(title: "No Images Selected", message: "Please select the images you'd like to share by tapping the checkmarks in the bottom right of the images.", preferredStyle: UIAlertControllerStyle.Alert)
            
            noChecksAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler:nil))
            
            self.presentViewController(noChecksAlert, animated: true, completion: nil)
        } else {
            
            var imgHolder: [UIImage] = []
            for index in 0..<photosAsset!.count {
                if contains(selectedHolder, index) {
                    let indexPath = NSIndexPath(forItem: index, inSection: 0)
                    let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? PicCell
                    if let cell = cell {
                        imgHolder.append(cell.picImageView.image!)
                    }
                }
            }
            
            let activityVC: UIActivityViewController = UIActivityViewController(activityItems: imgHolder, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func handleTrashPressed(sender: PicCell) {
        
        let indexPath = collectionView.indexPathForCell(sender)
        
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (alertAction) -> Void in
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                let request = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                if let indexPath = indexPath {
                    request.removeAssets([self.photosAsset![indexPath.item]])
                }
            }, completionHandler: { (success, error) -> Void in
                if success {
                    println("Deleted picture.")
                    self.refreshPhotosFromCollection()
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
