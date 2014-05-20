//
//  CameraViewController.m
//  Ribbit
//
//  Created by Luke on 19/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    #pragma mark - Setup camera
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    // tell imagePicker that CameraViewController is its delegate
    self.imagePicker.delegate = self;
    
    // requires memory management
    self.imagePicker.allowsEditing = NO;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // dismiss view controller presented modally
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // return user back to the inbox tab
    // select inbox tab index array from TabBarController using setSelectedIndex
    [self.tabBarController setSelectedIndex:0];
}

@end
