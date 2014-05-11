//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Luke on 11/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "EditFriendsViewController.h"

#import <Parse/Parse.h>

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
