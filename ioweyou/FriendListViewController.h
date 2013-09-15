//
//  FriendListViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 15.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *friends;

@end
