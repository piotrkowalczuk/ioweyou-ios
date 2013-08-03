//
//  LoginViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 07.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "LoginViewController.h"
#import "IOUAppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {}];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if(appDelegate.session.isOpen) {
        [self performSegueWithIdentifier:@"loginRedirection" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClickHandler:(id)sender
{
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (appDelegate.session.isOpen) {
        [self performSegueWithIdentifier:@"loginRedirection" sender:self];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            appDelegate.session = [[FBSession alloc] init];
        }
    
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self performSegueWithIdentifier:@"loginRedirection" sender:self];
        }];
        
    }
}

@end
