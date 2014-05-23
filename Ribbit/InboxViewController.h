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

#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, strong) PFObject *selectedMessage;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

- (IBAction)logout:(id)sender;

@end
