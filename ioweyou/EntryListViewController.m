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

@interface EntryListViewController (er)

@end

@implementation EntryListViewController

@synthesize tableView = _tableView;
@synthesize results = _results;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    self.tableView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://ioweyou.local.tld:8000/entries?uid=100000284981757&apiToken=1e118814-fec7-40e3-9230-e2e2b745332c"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
        self.results = jsonObject;
        [self.tableView reloadData];
    } failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
        NSLog(@"Received an HTTP %d", response.statusCode);
        NSLog(@"The error was: %@", error);
    }];
    
    [operation start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

//    NSString *position = [entry objectForKey:@"position"];
    
//    NSDictionary *contractor;
//    if ([position isEqual:@"lender"]) {
//        contractor = [entry objectForKey:@"debtor"];
//    } else {
//        contractor = [entry objectForKey:@"lender"];
//    }
//    contractor = [entry objectForKey:@"lender"];
    NSString *firstName = [entry objectForKey:@"debtor_first_name"];
    NSString *lastName = [entry objectForKey:@"debtor_last_name"];
    NSString *username = [entry objectForKey:@"debtor_username"];
    NSString *name = [entry objectForKey:@"name"];
    NSString *date = [entry objectForKey:@"created_at"];
    NSString *value = [entry objectForKey:@"value"];

    cell.firstLine.text = name;
    cell.thirdLine.text = date;
    cell.rightLine.text = value;
    cell.secondLine.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", username]]];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"entryDetails" sender:indexPath];
}


@end
