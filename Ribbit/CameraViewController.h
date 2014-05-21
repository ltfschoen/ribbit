//
//  CameraViewController.h
//  Ribbit
//
//  Created by Luke on 19/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

// property to store image for use throughout the rest of the view controller
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *videoFilePath;

@property (nonatomic, strong) PFRelation *friendsRelation;

// add friends @property so can reference anywhere in View Controller
@property (nonatomic, strong) NSArray *friends;

@property (nonatomic, strong) NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;

- (IBAction)send:(id)sender;

// helper instance method for uploading images and videos to Parse.com
- (void)uploadMessage;

// helper instance method signature for resizing images. addit parameters are width and height
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;


@end

