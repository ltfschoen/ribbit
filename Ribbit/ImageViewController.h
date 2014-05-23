//
//  ImageViewController.h
//  Ribbit
//
//  Created by Luke on 21/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
