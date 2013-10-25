//
//  AddEntryViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 12.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "EntryAddViewController.h"
#import "FriendListViewController.h"

@interface EntryAddViewController ()

@end

@implementation EntryAddViewController

@synthesize nameInput = _nameInput;
@synthesize valueInput = _valueInput;
@synthesize descriptionInput = _descriptionInput;
@synthesize includeMeInput = _includeMeInput;
@synthesize pickContractorsButton = _pickContractorsButton;
@synthesize entry = _entry;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)indexPath {
    if([segue.identifier isEqualToString:@"pickContractors"]){
        self.entry = [[NSMutableDictionary alloc] init];
        
        [self populateEntry];
        FriendListViewController *controller = (FriendListViewController *)segue.destinationViewController;
        [controller setEntry:self.entry];
        NSLog(@"prepareForSegue: %@", self.entry);
    }
}


- (void)populateEntry
{
    NSNumber *segmentIndex = [NSNumber numberWithInteger:[self.includeMeInput selectedSegmentIndex]];
    NSString *newValue = [[self.valueInput text] stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSLog(@"%@", newValue);
    [self.entry setValue:[self.nameInput text] forKey:@"name"];
    [self.entry setValue:newValue forKey:@"value"];
    [self.entry setValue:[self.descriptionInput text] forKey:@"description"];
    [self.entry setValue:segmentIndex forKey:@"includeMe"];

}

@end
