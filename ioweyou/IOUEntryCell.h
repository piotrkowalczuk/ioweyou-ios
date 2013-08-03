//
//  IOUEntryCell.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IOUEntryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *firstLine;
@property (nonatomic, weak) IBOutlet UILabel *secondLine;
@property (nonatomic, weak) IBOutlet UILabel *thirdLine;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *rightLine;
@end
