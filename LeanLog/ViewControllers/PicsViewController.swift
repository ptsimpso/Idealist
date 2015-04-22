//
//  PicsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/19/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import Photos

class PicsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PicCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedHolder: Set<Int> = []
    var idea: Idea!
    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult? // Array of photos found in collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization({ (authStatus) in
            if authStatus == PHAuthorizationStatus.Denied {
                var alert = UIAlertController(title: "Need Photos Permission", message: "Please go Settings > Privacy > Photos in the Settings app and grant Idealist access.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.fetchIdeaAlbum()
            }
        })
    }
    
    func fetchIdeaAlbum() {
        // Check if folder for this idea exists. If not, create it.
        let ideaAlbumTitle = "Idealist\(Int(idea.createdAt.timeIntervalSince1970))"
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", ideaAlbumTitle)
        
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype:.Any, options: fetchOptions)
        if let firstObj: AnyObject = collection.firstObject {
            albumFound = true
            assetCollection = firstObj as! PHAssetCollection
            println("Found album...")
        } else {
            // Create pic folder for idea
            var albumPlaceholder: PHObjectPlaceholder!
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(ideaAlbumTitle)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
                }, completionHandler: { (success, error) -> Void in
                    if success {
                        println("Created new folder")
                        let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil)
                        self.assetCollection = collection.firstObject as! PHAssetCollection
                    } else {
                        println("Photo folder creation failure.")
                    }
                    self.albumFound = success
            })
        }
        
        refreshPhotosFromCollection()
    }
    
    func refreshPhotosFromCollection() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        println("Fetching assets...")
        photosAsset = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: fetchOptions)
        
        self.collectionView.reloadData()
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
        // PHImageManagerMaximumSize
        if let cell = cell {
            
            let asset: PHAsset = photosAsset![indexPath.item] as! PHAsset
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (result: UIImage!, info: [NSObject : AnyObject]!) -> Void in
                
                let degraded = info[PHImageResultIsDegradedKey] as! NSNumber
                if !degraded.boolValue {
                    let imageInfo = JTSImageInfo()
                    imageInfo.image = result
                    imageInfo.referenceRect = cell.frame
                    imageInfo.referenceView = cell.superview
                    
                    let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
                    imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOriginalPosition)
                }
                
            }
        }
    }
    
    func handleCheckPressed(sender: PicCell) {
        let indexPath = self.collectionView.indexPathForCell(sender)
        if let indexPath = indexPath {
            if selectedHolder.contains(indexPath.item) {
                selectedHolder.remove(indexPath.item)
                sender.checkButton.setBackgroundImage(UIImage(named: "noCheck"), forState: UIControlState.Normal)
                sender.checkButton.backgroundColor = UIColor.whiteColor()
            } else {
                selectedHolder.insert(indexPath.item)
                sender.checkButton.setBackgroundImage(UIImage(named: "yesCheck"), forState: UIControlState.Normal)
                sender.checkButton.backgroundColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
            }
        }
    }

    @IBAction func sharePicsPressed(sender: UIBarButtonItem) {
        if selectedHolder.count == 0 {
            var noChecksAlert = UIAlertController(title: "No Images Selected", message: "Please select the images you'd like to share by tapping the checkmarks in the bottom right of the images.", preferredStyle: UIAlertControllerStyle.Alert)
            
            noChecksAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler:nil))
            
            self.presentViewController(noChecksAlert, animated: true, completion: nil)
        } else {
            
            var imgHolder: [UIImage] = []
            for index in 0..<photosAsset!.count {
                if selectedHolder.contains(index) {
                    let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! PicCell
                    imgHolder.append(cell.picImageView.image!)
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
                    dispatch_async(dispatch_get_main_queue(),{
                        self.refreshPhotosFromCollection()
                    })
                    
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func addImagePressed(sender: UIButton) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Denied {
            var alert = UIAlertController(title: "Need Photos Permission", message: "Please go Settings > Privacy > Photos in the Settings app and grant Idealist access.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let optionMenu = UIAlertController(title:nil, message:"Add Image", preferredStyle: .ActionSheet)
            
            let takePhoto = UIAlertAction(title: "Take New Photo", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    let picker = UIImagePickerController()
                    picker.navigationBar.barTintColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
                    picker.navigationBar.tintColor = UIColor.whiteColor()
                    picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
                    picker.sourceType = .Camera
                    picker.delegate = self
                    picker.allowsEditing = false
                    self.presentViewController(picker, animated: true, completion: nil)
                }
                
            })
            let photoLibrary = UIAlertAction(title: "Select From Library", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                let picker = UIImagePickerController()
                picker.navigationBar.barTintColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
                picker.navigationBar.tintColor = UIColor.whiteColor()
                picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
                picker.sourceType = .PhotoLibrary
                picker.delegate = self
                picker.allowsEditing = false
                self.presentViewController(picker, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
            
            optionMenu.addAction(takePhoto)
            optionMenu.addAction(photoLibrary)
            optionMenu.addAction(cancelAction)
            
            optionMenu.popoverPresentationController!.sourceView = self.view
            optionMenu.popoverPresentationController!.sourceRect = CGRectMake(self.view.frame.width / 2.0, self.view.frame.height - 60, 1.0, 1.0)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
    // MARK: Image Picker Delegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // code
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
            albumChangeRequest.addAssets([assetPlaceholder])
        }, completionHandler: { (success, error) -> Void in
            if success {
                println("Added new picture.")
                dispatch_async(dispatch_get_main_queue(),{
                    self.refreshPhotosFromCollection()
                    picker.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
}
