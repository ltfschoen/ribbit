//
//  ImageViewController.m
//  Ribbit
//
//  Created by Luke on 21/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // load the imageView @property with the image passed from prepareForSegue in the InboxViewController
    // download the file from Parse.com. message only contains the reference for the file, not the actual file itself. the file is stored as a PFFile Object
    PFFile *imageFile = [self.message objectForKey:@"file"];
    
    // PFFile Class has a URL property that contains the URL to get the image from Parse.com
    // use this URL to load the NSData Object and one of the convenience methods for downloading
    // then set the imageView from the NSData variable
    // firstly create an NSString variable to store the URL, which is of this type
    // load it with the initWithString method
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    // declare NSData Object and set it
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    // set new image view with this new image data
    self.imageView.image = [UIImage imageWithData:imageData];
    // add a title to be shown in the Nav area of the Image View Controller that loads containing the image and set it to the name of the sender
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
}

@end
