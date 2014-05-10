//
//  LoginViewController.m
//  Ribbit
//
//  Created by Luke on 9/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import "LoginViewController.h"

#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *test = @"test";
    NSLog(@"%@", test);
}

- (IBAction)login:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Please enter values for username and password fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        // show alert
        [alertView show];
    } else {
        // asynchronous back-end transaction to Parse.com by calling login method
        // 'logInWith..' is a Class method so not need instance variable of an Object
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            // run the following when back-end transaction complete and response routed
            // into this block to be handled as successful creation or error
            // check if error variable is set to null (perceived as false/NO)
            if (error) {
                // handle error using UIAlertView
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error attempting to login!" message:[error.userInfo objectForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                [alertView show];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
}
@end
