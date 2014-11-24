//
//  IOUViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "EntryListViewController.h"
#import "EntryDetailViewController.h"
#import "IOUEntryCell.h"
#import "IOUManager.h"
#import "IOUAppDelegate.h"
#import "UserManager.h"
#import "EntryManager.h"

@interface EntryListViewController ()
{
    NSManagedObjectContext *context;
    User *user;
}

@end

@implementation EntryListViewController

@synthesize tableView = _tableView;
@synthesize results = _results;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    self.tableView.delegate = self;
    
    [self.refreshControl
     addTarget:self
     action:@selector(refreshView:)
     forControlEvents:UIControlEventValueChanged
     ];
    
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    
    UserManager *userManager = [[UserManager alloc] init];
    user = [userManager fetchUser];
    
    
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager fetchAllsuccess:^(id responseObject) {
        self.results = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    
    EntryManager *entryManager = [[EntryManager alloc]init];
    [entryManager fetchAllsuccess:^(id responseObject) {
        self.results = responseObject;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *updated = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:updated];
    [refresh endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)indexPath {
    if([segue.identifier isEqualToString:@"entryDetails"]){
        EntryDetailViewController *controller = (EntryDetailViewController *)segue.destinationViewController;
        controller.entryId = [[self.results objectAtIndex:indexPath.row] valueForKey:@"id"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"entryDetails" sender:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    IOUEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IOUEntryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NSDictionary *entry = [self.results objectAtIndex:indexPath.row];
    [self populateTableCell:cell with:entry];
    
    return cell;
}

- (void)populateTableCell:(IOUEntryCell *)cell with:(NSDictionary *)entry
{
    NSString *name = [entry objectForKey:@"name"];
    NSString *value = [entry objectForKey:@"value"];

    cell.firstLine.text = name;
    cell.rightLine.text = value;
    
    UIColor *valueColor;

    if([user.ioweyouId isEqualToString:[[entry objectForKey:@"debtor_id"] stringValue]])
    {
        valueColor = [UIColor redColor];
    } else {
        valueColor = [UIColor greenColor];
    }
    
    cell.rightLine.textColor = valueColor;
}

- (void)scrollViewDidScroll: (UIScrollView *)scroll {
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scroll.contentOffset.y;
    NSInteger maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        
    }
}


@end
