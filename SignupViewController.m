//
//  SignupViewController.m
//  Ribbit
//
//  Created by Luke on 9/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "SignupViewController.h"

#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (IBAction)signup:(id)sender {
    
    // check for appropriate data to keep values clean
    // get values from Storyboard text fields and store as variables
    // check for no leading or trailing whitespaces
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // check all fields set (no blank data) or give users error message
    if ([username length] == 0 || [password length] == 0 || [email length] ==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                  message:@"Please enter values for username, password, and email fields"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        // show alert
        [alertView show];
    } else {
    
        // create a new user Object with PFUser variable and initializer method
        // refer to documentation at https://www.parse.com/docs/ios_guide#users/iOS
        PFUser *newUser = [PFUser user];
        
        // set required username and password properties of PFUser with values
        // stored above as entered from the Storyboard TextFields
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        // asynchronous back-end transaction saves data to Parse.com by calling save method
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // run the following when back-end transaction complete and response routed
            // into this block to be handled as successful creation or error
            // check if error variable is set to null (perceived as false/NO)
            if (error) {
                // handle error using UIAlertView
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error creating new user!" message:[error.userInfo objectForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            } else {
                // handle successfully created and saved new user by return to inbox
                // return to previous spot in navigation flow use special methods from
                // Navigation Controller (InboxViewController embedded inside)
                // access Navigation Controller (property of ViewController)
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
        }];
    }

}

@end
