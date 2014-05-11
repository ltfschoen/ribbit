//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Luke on 11/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // queries all users by default
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    // successful query returns an array of PFObjects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
           
            
        } else {
            // store array of returned PFUser (subclass of PFObject) into "allUsers" @property to use as data source for TableView
            self.allUsers = objects;
            
            // send message to TableView that new data has been obtained asychronously
            [self.tableView reloadData];
            
            //NSLog(@"%@", self.allUsers);
        }
    }];
    
    // set the currentUser @property. get currentUser using the 'currentUser' method of the PFUser Class
    self.currentUser = [PFUser currentUser];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    // set number of sections to 1
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    // set number of rows to the number of users in the allUsers array
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // set text of cell as the username
    // get PFUser from allUsers using indexPath.row as the index
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    // get username property for the label
    cell.textLabel.text = user.username;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *) indexPath
{
    // manually deselect the row of the TableViewCell (as the blue coloured highlight backgorund which appears when tap a row does not disappear automatically)
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // add or delete selected user
    // indicator that user added or deleted
    // use special property of UITableViewCell Class called 'accessory type' for indicator
    // set value to display icon on right side of cell
    // system configuration of table views in
    // Table View Programming Guide for iOS
    // https://developer.apple.com/library/ios/documentation/userexperience/conceptual/tableview_iphone/TableViewStyles/TableViewCharacteristics.html#//apple_ref/doc/uid/TP40007451-CH3-SW1
    // try Selection List checkmark indicate friendship
    
    // add user in front-end with reference to table view cell to show checkmark using indexPath parameter of this method
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // define new PFRelation with reference to currentUser @property in header file of type PFUser
    // relation for given key is created if not already exist, otherwise the relation is returned
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];

    // retrieve tapped on User with objectAtIndex method
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    // added object is the User who was tapped on
    [friendsRelation addObject:user];
    
    // save data to Back-End using asynchronous block method
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
    
}



@end
