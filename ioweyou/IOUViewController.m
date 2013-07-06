//
//  IOUViewController.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "IOUViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "IOUEntryCell.h"

@interface IOUViewController ()

@end

@implementation IOUViewController

@synthesize tableView = _tableView;
@synthesize results = _results;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    self.tableView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://ioweyou.local.tld:8000/api/entry/?format=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
        self.results = [jsonObject objectForKey:@"objects"];
//NSLog(@"%@", self.results);
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    IOUEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IOUEntryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell.
    NSDictionary *entry = [self.results objectAtIndex:indexPath.row];
    NSDictionary *debtor = [entry objectForKey:@"debtor"];
    cell.userName.text = [debtor objectForKey:@"first_name"];
    cell.entryName.text = [entry objectForKey:@"name"];
    cell.date.text = [entry objectForKey:@"created_at"];
    [cell.userAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [debtor objectForKey:@"username"]]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


@end
