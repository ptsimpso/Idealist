//
//  PicsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/19/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class PicsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PicCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var pics: [UIImage] = []
    var selectedHolder: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for index in 1...3 {
            let img = UIImage(named: "sections")
            pics.append(img!)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.frame.width / 2 - 3, round((self.collectionView.frame.width / 2 - 3) * 1.775))
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! PicCell
        
        let img = pics[indexPath.row]
        cell.picImageView.image = img
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
        
        if let cell = cell {
            let imageInfo = JTSImageInfo()
            imageInfo.image = pics[indexPath.row]
            imageInfo.referenceRect = cell.frame
            imageInfo.referenceView = cell.superview
            
            let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
            imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOriginalPosition)
        }
    }
    
    func handleCheckPressed(sender: PicCell) {
        let indexPath = self.collectionView.indexPathForCell(sender)
        if let indexPath = indexPath {
            if contains(selectedHolder, indexPath.row) {
                selectedHolder.removeAtIndex(find(selectedHolder, indexPath.row)!)
                sender.checkButton.setBackgroundImage(UIImage(named: "noCheck"), forState: UIControlState.Normal)
                sender.checkButton.backgroundColor = UIColor.whiteColor()
            } else {
                selectedHolder.append(indexPath.row)
                sender.checkButton.setBackgroundImage(UIImage(named: "yesCheck"), forState: UIControlState.Normal)
                sender.checkButton.backgroundColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
            }
        }
    }

    @IBAction func sharePicsPressed(sender: UIBarButtonItem) {
        if selectedHolder.count == 0 {
            var noChecksAlert = UIAlertController(title: "No Pictures Selected", message: "Please select the pictures you'd like to share by tapping the checkmarks in the bottom right of the images.", preferredStyle: UIAlertControllerStyle.Alert)
            
            noChecksAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler:nil))
            
            self.presentViewController(noChecksAlert, animated: true, completion: nil)
        } else {
            
            var imgHolder: [UIImage] = []
            for index in 0..<pics.count {
                if contains(selectedHolder, index) {
                    imgHolder.append(pics[index])
                }
            }
            
            let activityVC: UIActivityViewController = UIActivityViewController(activityItems: imgHolder, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func handleTrashPressed(sender: PicCell) {
        // TODO
    }
}
