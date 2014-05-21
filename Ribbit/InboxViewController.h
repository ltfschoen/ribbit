//
//  InboxViewController.h
//  Ribbit
//
//  Created by Luke on 9/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <UIKit/UIKit.h>

// <> - search certain preset system paths (i.e. frameworks)
#import <Parse/Parse.h>

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;

- (IBAction)logout:(id)sender;

@end
