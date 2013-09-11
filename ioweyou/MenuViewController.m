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
    NSURL *url = [NSURL URLWithString:@"http://ioweyou.local.tld:8000/entries/summary?uid=100000284981757&apiToken=1d21f9e5-a233-4fd3-bab9-2e3768b3457c"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
        self.summary = [jsonObject objectForKey:@"summary"];;
        self.summaryButton.titleLabel.text = self.summary;    } failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
