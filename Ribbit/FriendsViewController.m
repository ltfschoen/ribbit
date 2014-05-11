//
//  FriendsViewController.m
//  Ribbit
//
//  Created by Luke on 11/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set @property friendsRelation. currentUser has relation as part of their current data
    // in Data Browser of Parse.com the relation is stored under column (property of User Class) with key 'FriendsRelation'

    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    // call to back-end to get all data stored in PFRelation using query object
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    
    // execute. tabbed then press enter for the stub and delete code placeholder
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // check for error
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            // save NSArray (returned Data Source for the Table View) to @property 'friends'
            // call ReloadData method once we have the data to refresh the Table View
            self.friends = objects;
            
            [self.tableView reloadData];
            
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // set text of cell as the friends
    // get PFUser from friends array using indexPath.row as the index
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    // get username property for the label
    cell.textLabel.text = user.username;
    
    return cell;
}



@end
