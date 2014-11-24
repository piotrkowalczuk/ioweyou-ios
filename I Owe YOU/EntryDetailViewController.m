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
    if (![[self.entry objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
        [self.description setText:[self.entry objectForKey:@"description"]];
    }
    [self.debtor_name setText:[NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"debtor_first_name"], [self.entry objectForKey:@"debtor_last_name"]]];
    [self.lender_name setText:[NSString stringWithFormat:@"%@ %@", [self.entry objectForKey:@"lender_first_name"], [self.entry objectForKey:@"lender_last_name"]]];
    [self.value setText:[NSString stringWithFormat:@"%@", [self.entry objectForKey:@"value"]]];
    [self.debtor_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"debtor_username"]]]];
    [self.lender_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [self.entry objectForKey:@"lender_username"]]]];
    
    NSArray *statusList = [[NSArray alloc] initWithObjects:@"Open", @"Accepted", @"Rejected", nil];
    NSUInteger statusIndex = (NSUInteger)[[self.entry objectForKey:@"status"] integerValue];
    
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
        UIAlertController* actionSheet=   [UIAlertController
                                           alertControllerWithTitle:@"Actions"
                                           message:@"choose one of available"
                                           preferredStyle:UIAlertControllerStyleAlert];
        
        if([user.ioweyouId isEqualToString:[[self.entry objectForKey:@"debtor_id"] stringValue]])
        {
            UIAlertAction *acceptAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Accept", @"Accept action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self acceptEntry];
                                           }];
            
            UIAlertAction *rejectAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Reject", @"Reject action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self rejectEntry];
                                           }];
            
            [actionSheet addAction:acceptAction];
            [actionSheet addAction:rejectAction];
        } else {
            UIAlertAction *editAction = [UIAlertAction
                                         actionWithTitle:NSLocalizedString(@"Edit", @"Edit action")
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action)
                                         {
                                             [self performSegueWithIdentifier:@"editEntry" sender:@"lol"];
                                         }];
            
            UIAlertAction *deleteAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Delete", @"Delete Reject")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self deleteEntry];
                                           }];
            
            [actionSheet addAction:editAction];
            [actionSheet addAction:deleteAction];
        }
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        [actionSheet addAction:cancelAction];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
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
