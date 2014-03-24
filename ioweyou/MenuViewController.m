//
//  IOUViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 07.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "MenuViewController.h"
#import "IOUAppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "IOUManager.h"
#import "UserManager.h"
#import "EntryManager.h"
#import "EntryDetailViewController.h"

@interface MenuViewController ()
{
    NSManagedObjectContext *context;
}

@end

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize summary = _summary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];

    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {}];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self handleSession];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchSummary
{
    EntryManager *entryManager = [[EntryManager alloc]init];
    
    [entryManager fetchSummaryWithSuccess:^(id responseObject) {
        [self.summary setTitle:[responseObject objectForKey:@"summary"]];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (void)handleSession
{
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if(appDelegate.session.isOpen) {
        NSString *facebookToken = [[[FBSession activeSession]accessTokenData]accessToken];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:facebookToken, @"pass", nil];
        
        [[IOUManager sharedManager] postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            UserManager *userManager = [[UserManager alloc] init];
            [userManager createOrUpdateUserWithUsername:[responseObject valueForKey:@"username"] firstName:[responseObject valueForKey:@"first_name"] lastName: [responseObject valueForKey:@"last_name"] email:[responseObject valueForKey:@"email"] facebookId:[responseObject valueForKey:@"facebookId"] facebookToken:facebookToken ioweyouId:[responseObject valueForKey:@"ioweyouId"] ioweyouToken:[responseObject valueForKey:@"ioweyouToken"]];

            [self fetchSummary];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            appDelegate.session = [[FBSession alloc] init];
        }
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [FBSession setActiveSession:appDelegate.session];
                [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    if (!error) {
                        
                        NSString *facebookToken = [[[FBSession activeSession]accessTokenData]accessToken];

                        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:facebookToken, @"pass", nil];
                        
                        [[IOUManager sharedManager] postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            UserManager *userManager = [[UserManager alloc] init];
                            [userManager createOrUpdateUserWithUsername:[responseObject valueForKey:@"username"] firstName:[responseObject valueForKey:@"first_name"] lastName: [responseObject valueForKey:@"last_name"] email:[responseObject valueForKey:@"email"] facebookId:[responseObject valueForKey:@"facebookId"] facebookToken:facebookToken ioweyouId:[responseObject valueForKey:@"ioweyouId"] ioweyouToken:[responseObject valueForKey:@"ioweyouToken"]];
                            
                            [[IOUManager sharedManager] setAuthToken:[userManager getIOUToken]];
                            
                            [self fetchSummary];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"%@", error);
                        }];
                    }
                }];
            }
        }];
    }
}

@end
