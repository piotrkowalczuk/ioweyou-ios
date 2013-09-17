//
//  LoginViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 07.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "LoginViewController.h"
#import "IOUAppDelegate.h"
#import "IOUManager.h"
#import "User.h"
#import "UserManager.h"

@interface LoginViewController ()
{
    NSManagedObjectContext *context;
}

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
    context = [appDelegate managedObjectContext];
    
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {}];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if(appDelegate.session.isOpen) {
        NSString *facebookToken = [[[FBSession activeSession]accessTokenData]accessToken];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:facebookToken, @"pass", nil];
        
        [[IOUManager sharedManager] postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UserManager *userManager = [[UserManager alloc] init];
            [userManager createOrUpdateUserWithUsername:[responseObject valueForKey:@"username"] firstName:[responseObject valueForKey:@"first_name"] lastName: [responseObject valueForKey:@"last_name"] email:[responseObject valueForKey:@"email"] facebookId:[responseObject valueForKey:@"facebookId"] facebookToken:facebookToken ioweyouId:[responseObject valueForKey:@"ioweyouId"] ioweyouToken:[responseObject valueForKey:@"ioweyouToken"] inManagedObjectContext: context];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
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
            
            [FBSession setActiveSession:appDelegate.session];
            [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                if (!error) {
                    
                    NSString *facebookToken = [[[FBSession activeSession]accessTokenData]accessToken]; 
                    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:facebookToken, @"pass", nil];

                    [[IOUManager sharedManager] postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"%@", responseObject);
                        UserManager *userManager = [[UserManager alloc] init];
                        [userManager createOrUpdateUserWithUsername:[responseObject valueForKey:@"username"] firstName:[responseObject valueForKey:@"first_name"] lastName: [responseObject valueForKey:@"last_name"] email:[responseObject valueForKey:@"email"] facebookId:[responseObject valueForKey:@"facebookId"] facebookToken:facebookToken ioweyouId:[responseObject valueForKey:@"ioweyouId"] ioweyouToken:[responseObject valueForKey:@"ioweyouToken"] inManagedObjectContext: context];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@", error);
                    }];

                }
            }];

          [self performSegueWithIdentifier:@"loginRedirection" sender:self];
        }];
        
    }
}

@end
