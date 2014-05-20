//
//  CameraViewController.h
//  Ribbit
//
//  Created by Luke on 19/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

// property to store image for use throughout the rest of the view controller
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *videoFilePath;

@end
