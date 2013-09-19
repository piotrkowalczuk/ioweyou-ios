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
    
    if(![[self.entry objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:0]]){
        [self.actionSheetButton setEnabled:NO];
    }
    
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    
    UserManager *userManager = [[UserManager alloc] init];
    user = [userManager fetchUserInManagedObjectContext:context];
    
    self.title = [self.entry objectForKey:@"name"];
    self.description.text = [self.entry objectForKey:@"description"];
    self.debtor_name.text = [NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"debtor_first_name"], [self.entry objectForKey:@"debtor_last_name"]];
    self.lender_name.text = [NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"lender_first_name"], [self.entry objectForKey:@"lender_last_name"]];
    self.value.text = [NSString stringWithFormat:@"%@", [self.entry objectForKey:@"value"]];
    [self.status setText: [[self.entry objectForKey:@"status"] stringValue]];
    [self.debtor_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"debtor_username"]]]];
    [self.lender_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"lender_username"]]]];
    

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
