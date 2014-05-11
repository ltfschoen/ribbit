//
//  EditFriendsViewController.h
//  Ribbit
//
//  Created by Luke on 11/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <UIKit/UIKit.h>

// only need import file in header (not duplicate in .m)
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;

@property (nonatomic, strong) PFUser *currentUser;

@end
