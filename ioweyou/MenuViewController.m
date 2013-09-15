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

@interface MenuViewController ()
{
    NSManagedObjectContext *context;
}

@end

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize summary = _summary;
@synthesize summaryButton = _summaryButton;

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
    
    UserManager *userManager = [[UserManager alloc] init];
    NSDictionary *params = [userManager getAuthParamsInManagedObjectContext:context];
    

    [[IOUManager sharedManager] getPath:@"/entries/summary" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.summaryButton.titleLabel.text = [responseObject objectForKey:@"summary"];  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
