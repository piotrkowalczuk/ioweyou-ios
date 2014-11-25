//
//  EntryEditViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 19.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "EntryEditViewController.h"
#import "EntryDetailViewController.h"
#import "User.h"
#import "Entrymanager.h"

@interface EntryEditViewController ()
{
    NSManagedObjectContext *context;
    User *user;
}
@end

@implementation EntryEditViewController

@synthesize entryId = _entryId;
@synthesize entry = _entry;
@synthesize name = _name;
@synthesize value = _value;
@synthesize desc = _desc;

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
    
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager fetchOneById:self.entryId success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.entry = [responseObject mutableCopy];
        [self populateUI];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)populateUI {
    NSLog(@"%@", self.desc);
	[self.name setText:[self.entry valueForKey:@"name"]];
    [self.value setText:[self.entry valueForKey:@"value"]];
    if (![[self.entry objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
        [self.desc setText:[self.entry objectForKey:@"description"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)saveEntry:(id)sender {
    EntryManager *entryManager = [[EntryManager alloc]init];
    
    [self.entry setValue:self.name.text forKey:@"name"];
    [self.entry setValue:self.value.text forKey:@"value"];
    [self.entry setValue:self.desc.text forKey:@"description"];
    
    [entryManager modifyEntry:self.entry success:^(id responseObject) {
        if([responseObject valueForKey:@"isModified"]) {
            NSArray *array = [self.navigationController viewControllers];
            
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
