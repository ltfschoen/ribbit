//
//  FriendsViewController.h
//  Ribbit
//
//  Created by Luke on 11/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;

// add friends @property so can reference anywhere in View Controller
@property (nonatomic, strong) NSArray *friends;

@end
