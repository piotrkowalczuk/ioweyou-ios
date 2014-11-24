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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self fetchSummary];
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
        [self.summary setText:[responseObject objectForKey:@"summary"]];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
