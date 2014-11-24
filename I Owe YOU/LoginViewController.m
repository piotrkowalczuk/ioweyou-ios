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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self performSegueWithIdentifier:@"loginRedirection" sender:self];
        NSLog(@"Authorized.");
        return;
    }
    
    NSLog(@"Unauthorized.");
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonClickHandler:(id)sender
{
    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         IOUAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         [appDelegate sessionStateChanged:session state:state error:error];
         
         if (error) {
             NSLog(@"%@", error);
             return;
         }
         
         [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 NSLog(@"Facebook user: %@", user);
                 
                 NSString *facebookToken = [[[FBSession activeSession]accessTokenData]accessToken];
                 
                 NSLog(@"Facebook token: %@", facebookToken);
                 NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:facebookToken, @"pass", nil];
                 NSLog(@"%@", params);
                 [[IOUManager sharedManager] postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSLog(@"Login response: %@", responseObject);
                     
                     UserManager *userManager = [[UserManager alloc] init];
                     [[IOUManager sharedManager] setAuthToken:[responseObject valueForKey:@"ioweyouToken"]];
                     [userManager createOrUpdateUserWithUsername:[responseObject valueForKey:@"username"] firstName:[responseObject valueForKey:@"first_name"] lastName: [responseObject valueForKey:@"last_name"] email:[responseObject valueForKey:@"email"] facebookId:[responseObject valueForKey:@"facebookId"] facebookToken:facebookToken ioweyouId:[responseObject valueForKey:@"ioweyouId"] ioweyouToken:[responseObject valueForKey:@"ioweyouToken"]];
                     
                     [self performSegueWithIdentifier:@"loginRedirection" sender:self];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@", error);
                 }];
             }
         }];
     }];
}

@end
