//
//  EntryDetailViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "EntryDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"

@implementation EntryDetailViewController

@synthesize description = _description;

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
    
    self.title = [self.entry objectForKey:@"name"];
    self.description.text = [self.entry objectForKey:@"description"];
    self.debtor_name.text = [NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"debtor_first_name"], [self.entry objectForKey:@"debtor_last_name"]];
    self.lender_name.text = [NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"lender_first_name"], [self.entry objectForKey:@"lender_last_name"]];
    self.value.text = [NSString stringWithFormat:@"%@", [self.entry objectForKey:@"value"]];
    [self.debtor_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"debtor_username"]]]];
    [self.lender_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"lender_username"]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
