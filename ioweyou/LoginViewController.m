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
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {}];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if(appDelegate.session.isOpen) {
//[self performSegueWithIdentifier:@"loginRedirection" sender:self];
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
                    
                    NSString *facebookId = [user objectForKey:@"id"];
                    NSString *facebookToken = [[[FBSession activeSession]accessTokenData]accessToken];
                    
                    NSLog(@"%@", facebookId);
                    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:facebookToken, @"pass", nil];
                    
                    [[IOUManager sharedManager] postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self createOrUpdateUserWithUsername: [responseObject valueForKey:@"username"]
                                           firstName: [responseObject valueForKey:@"first_name"]
                                            lastName: [responseObject valueForKey:@"last_name"]
                                               email: [responseObject valueForKey:@"email"]
                                          facebookId: [responseObject valueForKey:@"facebookId"]
                                       facebookToken: facebookToken
                                           ioweyouId: [responseObject valueForKey:@"ioweyouId"]
                                        ioweyouToken: [responseObject valueForKey:@"ioweyouToken"]];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@", error);
                    }];

                }
            }];

          [self performSegueWithIdentifier:@"loginRedirection" sender:self];
        }];
        
    }
}

- (void) createOrUpdateUserWithUsername:(NSString *)username
                   firstName:(NSString *)firstName
                    lastName:(NSString *)lastName
                       email:(NSString *)email
                  facebookId:(NSString *)facebookId
               facebookToken:(NSString *)facebookToken
                   ioweyouId:(NSString *)ioweyouId
                ioweyouToken:(NSString *)ioweyouToken
{
    User *user;
    
    user = [self fetchUserWithUsername:username];
        
    if(!user){
        user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:context];
    }
    
    [user setFacebookId:facebookId];
    [user setFacebookToken:facebookToken];
    [user setUsername:username];
    [user setFirstName:firstName];
    [user setLastName:lastName];
    [user setEmail:email];
    [user setIoweyouId:ioweyouId];
    [user setIoweyouToken:ioweyouToken];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }

};

- (User *) fetchUserWithUsername:(NSString *)username
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([User class]) inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"username == %@", username];
    [request setPredicate:searchFilter];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (results == nil || [results count] == 0) {
        return NULL;
    } else {
        return [results objectAtIndex:0];
    }
}

@end
