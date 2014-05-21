//
//  InboxViewController.m
//  Ribbit
//
//  Created by Luke on 9/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

// "" - search in current project for header file (i.e. project directory code)
#import "InboxViewController.h"

#import "ImageViewController.h"


@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    
    // check if user logged in. show login page only when user not logged in
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current User: %@", currentUser.username);
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // query the new message class/table that we created in Parse.com database
    // only want list where our user id is in the list of recipient ids
    // (retrieve only messages sent to current user)
    // not want full list and then filter, as this is a waste of bandwidth and privacy issue
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    // apply where clause condition
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    // execute query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            // where matching messages found and now stored in 'objects' array
            // and stored in @property defined in the header file. then use @property as
            // data source for table view
            self.messages = objects;
            // refresh table view
            [self.tableView reloadData];
            NSLog(@"Retrieved %d messages", [self.messages count]);
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
    // Return the number of rows in the section.
    
    // count of data source
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // update Storyboard so prototype cell has identifier as 'Cell' also
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // username of person who sent the message, get message object that corresponds to
    // the row at this indexPath, where the message is a PFObject
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    
    // store senders username as 'senderName'
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    // check the value of the fileType string to determine if the message is a photo or a video
    // and show appropriate icon
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        // set imageView cell to image icon
        // each cell with default styling has optional imageView on left side 'cell.imageView'
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when tap message
    // if message is a picture then view image in new ImageViewController
    // firstly access the file type
    
    // updated to use @property to store the selected message
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    //PFObject *message = [self.messages objectAtIndex:indexPath.row];
    //NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        // perform Segue in Storyboard with identifier 'showImage'
        [self performSegueWithIdentifier:@"showImage" sender:self];
        // get image contained in the message displayed to the ImageViewController
        // pass data between view controllers with mechanism of setting @properties in the prepareForSegue method
    } else {
        // video file type situation
        // specify URL for the video content from PFFile Object
        // first assocate PFFile with this message
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        // set URL for movie player
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        // thumbnail to appear before video starts
        // start immediately, grab the thumbnail exactly at time specified not required so set to start at nearest keyframe which is better for performance purposes
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        // add movie player to View Controllers hierarchy so we can view it
        [self.view addSubview:self.moviePlayer.view];
        // set to run at full-screen after added view to hierarchy
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    // if message is a movie then use special control called MPMoviePlayerController to watch it
}

#pragma mark - IBActions

- (IBAction)logout:(id)sender {
    
    // log out user and take them back to the login page automatically calling login segue
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // check identifer of segue incase there is more than one in view controller
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        // access properties of 'destinationViewController' variable
        // after firstly casting it to the appropriate type
        // declare new ImageViewController variable (after #importing it)
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        // now can access properties of imageViewController variable
        // store message that was selected into a new @property defined in header 'selectedMessage'
        // and set it in didSelectRowAtIndexPath when the message was selected
        // now set the message property to the stored @property 'selectedMessage'
        imageViewController.message = self.selectedMessage;
    }
}

@end
