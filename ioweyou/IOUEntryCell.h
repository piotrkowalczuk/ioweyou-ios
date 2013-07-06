//
//  IOUEntryCell.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IOUEntryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UILabel *entryName;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UIImageView *userAvatar;
@end
