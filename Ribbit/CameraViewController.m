//
//  CameraViewController.m
//  Ribbit
//
//  Created by Luke on 19/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "CameraViewController.h"

// obtain constant values of media types
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    #pragma mark - Friends List Query
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
    #pragma mark - Setup camera
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    // tell imagePicker that CameraViewController is its delegate
    self.imagePicker.delegate = self;
    
    // requires memory management
    self.imagePicker.allowsEditing = NO;
    
    // set maximum duration of videos
    self.imagePicker.videoMaximumDuration = 10; // 10 seconds
    
    // convenience method to check if camera is available
    // otherwise setting source type to camera does not work with simulator
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // use source type just set
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    
    #pragma mark - Present camera modally
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
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
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // simply want to display username of each friend
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    
    
    // prevent recycling of checkmarks from earlier cells appearing when scrolling
    // check array of recipients and if user for current row is in the array show the checkmark, ese leave blank
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // get current Users index using the indexPath to efficiently refer to user when handling requests with Parse.com
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    // toggle the checkmark
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
    
    // print the array of recipients to test
    NSLog(@"%@", self.recipients);
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // dismiss view controller presented modally
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // return user back to the inbox tab
    // select inbox tab index array from TabBarController using setSelectedIndex
    [self.tabBarController setSelectedIndex:0];
}

// information stored in NSDictionary with 'info' key (shown below)
// didFinishPickingMediaWithInfo is the UIImagePickerController delegate method that is called when a photo or video is taken
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // create variable to hold media type
    // so we can inspect media type string variable
    // different media types stored as constants as part of the Mobile Core Services Framework #imported rather than hard coded
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // convert Core Foundation (CF) String to Next Step (NS) String counterpart (different type of string data structure) with a simple cast (NSString *) infront of kU...
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // photo taken or selected
        
        // use @property in header file used for storing image for use throughout the rest of the view controller
        // set (where the image is in the NSDictionary with the 'info' key)
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // check that camera itself is being used before storing
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save image using special function from UIKit Framework
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else {
        // video taken on selected
        // when a video is captured, it is stored in iOS internal path. reference with a key that is stored in the NSDictionary. movie file itself is not stored in the info NSDictionary use @property created in header file to store
        // pass in constant UIImagePickerControllerMediaURL
        // call the path method on this URL to get the local iOS path as a string
        self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        // allow ability to save the video to the photo album
        // check app will work on all devices
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
            // UIKit function to save videos to photo album on iPhone
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
        }
        // limit size of file to store so app works fast. Parse.com has limit of 10mb for free account
        
    }
    // dismiss modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - IBActions

- (IBAction)cancel:(id)sender {
    // reset @properties in the header file
    // call 'reset' method (refactored)
    [self reset];
    
    // return the user to the inbox
    [self.tabBarController setSelectedIndex:0];
    
    
}

- (IBAction)send:(id)sender {
    // check photo or movie is set. they are stored as @property of view controller
    // check length of string if zero
    if (self.image == nil && self.videoFilePath.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please try again..."
                                message:@"Please capture or select a photo or video to share."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else {
        // send message
        
        // helper method
        [self uploadMessage];
        
        // shift to after asych upload methods completed successfully to fix blank recipient id's being stored in the database
        
        // return to inbox after upload
        [self.tabBarController setSelectedIndex:0];
        

    }
}

#pragma mark - Helper methods

- (void)uploadMessage {
    
    // declare NSData Object and NSString for Filename for both image and video here for scoping purposes
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    // show message only if error (optionally using 3rd party popup)
    // check if image or video
    if (self.image != nil) {
        // call resizeImage helper method 320x480 using float values expected
        // shrink it if it is an image
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        
        // create NSData Object from image
        // use PNG instead of JPG representation as it can hold the same data (not vice versa)
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        
        // create NSData Object from video
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // error check
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error occurred..."
                                message:@"Please attempt to send your message again."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
            [alertView show];
        } else {
            // file successfully on Parse.com
            
            // instantiate message Object that associates this file with all recipients selected using PFObject for storing data
            // Class Name used to refer to these types of objects (similar to Table Name where similar ). All objects created with this Class Name are stored together
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            // add/store to 'Message' Object name similar to how done with NSDictionary
            
            // add file we just uploaded
            // associated PFFile with PFObject and Parse.com will manage relationship
            // Keys are like columns
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            // pass in array directly to Parse.com, which will store for us
            [message setObject:self.recipients forKey:@"recipientIds"];
            // store user id Object and username (from user collection)
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            // send
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error with save occurred..."
                                                                        message:@"Please attempt to send your message again."
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                } else {
                    // successfully uploaded and returned user to inbox
                    // no action required
                    
                    // reset @properties using DRY reuse method
                    // call 'reset' helper method (refactored)
                    [self reset];
                }
            }];
        }
    }];

}

- (void)reset {
    
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    // use CGSize (Core Graphics) to define the size of the rectangle that will be used as the size of new image
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    
    // create UIGraphics Context to manipulate image
    // UIGraphics BeginImageContext creates bitmap based graphics context for specified rectangular area. Use this for drawing within the context, then capture resulting image (redraw big image from camera as a smaller version of itself) context within a new UIImage variable
    // pass in size to work with
    UIGraphicsBeginImageContext(newSize);
    // send msg to image @property called 'drawInRect' and passing in the CGRect variable
    // smaller version of image exists in bitmap context that we created.
    [self.image drawInRect:newRectangle];
    // capture and store new bitmap context in new UIImage variable
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    // end context
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
