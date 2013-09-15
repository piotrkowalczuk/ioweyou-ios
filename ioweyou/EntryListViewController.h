//
//  IOUViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryListViewController : UITableViewController {
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *results;

@end
