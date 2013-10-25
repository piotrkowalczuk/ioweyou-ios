//
//  FriendListViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 15.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableDictionary *entry;

- (IBAction)saveEntry:(id)sender;

@end
