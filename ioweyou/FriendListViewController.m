//
//  FriendListViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 15.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "FriendListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"
#import "UserManager.h"
#import "EntryManager.h"
#import "IOUAppDelegate.h"
#import "IOUManager.h"
#import "IOUFriendCell.h"

@interface FriendListViewController ()
{
    NSManagedObjectContext *context;
    NSMutableArray *selectedCells;
    User *user;
}
@end

@implementation FriendListViewController

@synthesize tableView = _tableView;
@synthesize friends = _friends;
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
    [self.tableView setDataSource:self];
    self.tableView.delegate = self;

    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    
    UserManager *userManager = [[UserManager alloc] init];
    user = [userManager fetchUser];
    NSDictionary *params = [NSDictionary dictionary];
    
    [[IOUManager sharedManager] getPath:@"/user/friends" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setFriends:responseObject];
        [self initSelectedCellsMutableArray];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    NSInteger cellIndex = [indexPath row];
    
    IOUFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IOUFriendCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *entry = [self.friends objectAtIndex:cellIndex];

    if ([[selectedCells objectAtIndex:cellIndex] isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self populateTableCell:cell with:entry];
    
    return cell;
}

- (void)populateTableCell:(IOUFriendCell *)cell with:(NSDictionary *)friend
{
    NSString *username = [friend objectForKey:@"username"];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [friend objectForKey:@"first_name"], [friend objectForKey:@"last_name"]];
    
    cell.friendName.text = name;
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", username]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [selectedCells replaceObjectAtIndex:[indexPath row] withObject:[[NSNumber alloc] initWithInt:0]];
    }else{
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedCells replaceObjectAtIndex:[indexPath row] withObject:[[NSNumber alloc] initWithInt:1]];
    }
}

- (void)initSelectedCellsMutableArray
{
    NSInteger length = [self.friends count];
    selectedCells = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < length; i++) {
        [selectedCells addObject:[[NSNumber alloc] initWithInt:0]];
    }
}
- (IBAction)saveEntry:(id)sender {
    EntryManager *entryManager = [[EntryManager alloc]init];
    NSInteger length = [selectedCells count];
    NSMutableArray *contractors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < length; i++) {
        if ([[selectedCells objectAtIndex:i] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [contractors addObject:[[self.friends objectAtIndex:i] valueForKey:@"id"]];
        }
    }

    [self.entry setValue:contractors forKey:@"contractors"];
    
    [entryManager createEntry:self.entry success:^(id responseObject) {
        if([responseObject valueForKey:@"isCreated"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
@end
