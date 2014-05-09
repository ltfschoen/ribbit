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

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // test saving data on Parse.com SDK by calling their API
    // define creates Parse.com table named "TestObject"
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    
    // sets value "bar" for key "foo" in row of the database table
    // [testObject setObject:@"bar" forKey:@"foo"];
    testObject[@"foo"] = @"bar";
    
    // save method to save data on Parse.com back-end
    [testObject saveInBackground];
    
    // test initial functionality of Storyboard segue
    [self performSegueWithIdentifier:@"showLogin" sender:self];
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

@end
