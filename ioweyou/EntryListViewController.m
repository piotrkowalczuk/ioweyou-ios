//
//  IOUViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "EntryListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "IOUEntryCell.h"
#import "IOUManager.h"
#import "UserManager.h"
#import "IOUAppDelegate.h"
#import "EntryDetailViewController.h"

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
    
    IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    
    UserManager *userManager = [[UserManager alloc] init];
    user = [userManager fetchUserInManagedObjectContext:context];
    NSDictionary *params = [userManager getAuthParamsInManagedObjectContext:context];
    
    [[IOUManager sharedManager] getPath:@"/entries" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.results = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];


}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)indexPath {
    if([segue.identifier isEqualToString:@"entryDetails"]){
        EntryDetailViewController *controller = (EntryDetailViewController *)segue.destinationViewController;
        controller.entry = [self.results objectAtIndex:indexPath.row];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    NSString *firstName = [entry objectForKey:@"debtor_first_name"];
    NSString *lastName = [entry objectForKey:@"debtor_last_name"];
    NSString *username = [entry objectForKey:@"debtor_username"];
    NSString *name = [entry objectForKey:@"name"];
    NSString *date = [entry objectForKey:@"created_at"];
    NSString *value = [entry objectForKey:@"value"];

    cell.firstLine.text = name;
    cell.thirdLine.text = date;
    cell.rightLine.text = value;
    
    UIColor *valueColor;

    if([user.ioweyouId isEqualToString:[[entry objectForKey:@"debtor_id"] stringValue]])
    {
        valueColor = [UIColor redColor];
    } else {
        valueColor = [UIColor greenColor];
    }
    
    cell.rightLine.textColor = valueColor;
    
    cell.secondLine.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", username]]];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
