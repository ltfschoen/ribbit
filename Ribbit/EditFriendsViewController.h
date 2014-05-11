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

// purpose of this view controller is to add/remove friends from list
@interface EditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;

@property (nonatomic, strong) PFUser *currentUser;

// mutable array so can add/remove
@property (nonatomic, strong) NSMutableArray *friends;

// define helper method to return boolean to check if friend
- (BOOL)isFriend:(PFUser *)user;

@end
