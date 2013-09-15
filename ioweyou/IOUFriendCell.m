//
//  IOUFriendCell.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 16.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "IOUFriendCell.h"

@implementation IOUFriendCell

@synthesize friendName = _friendName;
@synthesize image = _image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
