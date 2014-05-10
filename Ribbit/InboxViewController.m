//
//  InboxViewController.m
//  Ribbit
//
//  Created by Luke on 9/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

// "" - search in current project for header file (i.e. project directory code)
#import "InboxViewController.h"

// <> - search certain preset system paths (i.e. frameworks)
#import <Parse/Parse.h>

@interface InboxViewController ()

- (IBAction)logout:(id)sender;

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // check if user logged in. show login page only when user not logged in
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current User: %@", currentUser.username);
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (IBAction)logout:(id)sender {
    
    // log out user and take them back to the login page automatically calling login segue
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // check identifer of segue incase there is more than one in view controller
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
