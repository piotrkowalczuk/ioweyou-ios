//
//  EntryEditViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 19.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "EntryEditViewController.h"
#import "User.h"
#import "Entrymanager.h"

@interface EntryEditViewController ()
{
    NSManagedObjectContext *context;
    User *user;
}
@end

@implementation EntryEditViewController

@synthesize entry = _entry;
@synthesize name = _name;
@synthesize value = _value;
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
	[self.name setText:[self.entry valueForKey:@"name"]];
    [self.value setText:[self.entry valueForKey:@"value"]];
    [self.description setText:[self.entry valueForKey:@"description"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)saveEntry:(id)sender {
    EntryManager *entryManager = [[EntryManager alloc]init];
    
    [self.entry setValue:self.name.text forKey:@"name"];
    [self.entry setValue:self.value.text forKey:@"value"];
    [self.entry setValue:self.description.text forKey:@"description"];

    
    [entryManager modifyEntry:self.entry success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject valueForKey:@"isModified"]) {

        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
