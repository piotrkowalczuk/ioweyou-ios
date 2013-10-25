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
#import "UserManager.h"
#import "IOUAppDelegate.h"
#import "EntryManager.h"
#import "MenuViewController.h"
#import "EntryEditViewController.h"

@interface EntryDetailViewController ()
{
    NSManagedObjectContext *context;
    User *user;
}
@end

@implementation EntryDetailViewController

@synthesize description = _description;
@synthesize actionSheet = _actionSheet;
@synthesize actionSheetButton = _actionSheetButton;

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
    UserManager *userManager = [[UserManager alloc] init];
    user = [userManager fetchUser];
    
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager fetchOneById:self.entryId success:^(id responseObject) {
        self.entry = responseObject;
        
        [self updateActionSheetButton];
        [self populateUI];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)populateUI {
    
    [self setTitle:[self.entry objectForKey:@"name"]];
    [self.description setText:[self.entry objectForKey:@"description"]];
    [self.debtor_name setText:[NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"debtor_first_name"], [self.entry objectForKey:@"debtor_last_name"]]];
    [self.lender_name setText:[NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"lender_first_name"], [self.entry objectForKey:@"lender_last_name"]]];
    [self.value setText:[NSString stringWithFormat:@"%@", [self.entry objectForKey:@"value"]]];
    [self.debtor_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"debtor_username"]]]];
    [self.lender_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"lender_username"]]]];
    
    NSArray *statusList = [[NSArray alloc] initWithObjects:@"Open", @"Accepted", @"Rejected", nil];
    NSUInteger statusIndex = (NSUInteger)[[self.entry objectForKey:@"status"] integerValue];
    NSLog(@"%lu", (unsigned long)statusIndex);
    [self.status setText:[statusList objectAtIndex:statusIndex]];
}

- (void)updateActionSheetButton {
    if(![[self.entry objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:0]]){
        [self.actionSheetButton setEnabled:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickActionSheet:(id)sender {
    if (self.actionSheet) {
        // do nothing
    } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Available actions" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [actionSheet showInView:self.view];
            
            if([user.ioweyouId isEqualToString:[[self.entry objectForKey:@"debtor_id"] stringValue]])
            {
                [actionSheet addButtonWithTitle:@"Accept"];
                [actionSheet addButtonWithTitle:@"Reject"];
            } else {
                [actionSheet addButtonWithTitle:@"Edit"];
                [actionSheet addButtonWithTitle:@"Delete"];
            }
        
        
            [actionSheet addButtonWithTitle:@"Cancel"];
            [actionSheet setCancelButtonIndex:2];
            [actionSheet setDestructiveButtonIndex:1];
            [actionSheet showFromBarButtonItem:sender animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

    if([buttonTitle isEqualToString:@"Accept"]) {
        [self acceptEntry]; 
    }
    
    if([buttonTitle isEqualToString:@"Reject"]) {
        [self rejectEntry];
    }
    
    if([buttonTitle isEqualToString:@"Delete"]) {
        [self deleteEntry];
    }
    
    if([buttonTitle isEqualToString:@"Edit"]) {
        [self performSegueWithIdentifier:@"editEntry" sender:buttonTitle];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)indexPath {
    if([segue.identifier isEqualToString:@"editEntry"]){
        EntryDetailViewController *controller = (EntryDetailViewController *)segue.destinationViewController;
        controller.entryId = [self.entry valueForKey:@"id"];
    }
}
     
-(void)acceptEntry {
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager acceptEntry:[self.entry objectForKey:@"id"] success:^(id responseObject) {
        if([responseObject valueForKey:@"isModified"]) {
            [self.status setText:@"accepted"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)rejectEntry {
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager rejectEntry:[self.entry objectForKey:@"id"] success:^(id responseObject) {
        if([responseObject valueForKey:@"isModified"]) {
            [self.status setText:@"rejected"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)deleteEntry {
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager deleteEntry:[self.entry objectForKey:@"id"] success:^(id responseObject) {
        if([responseObject valueForKey:@"isModified"]) {
            MenuViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
