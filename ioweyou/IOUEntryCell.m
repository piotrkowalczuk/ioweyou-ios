//
//  IOUEntryCell.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 06.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "IOUEntryCell.h"

@implementation IOUEntryCell

@synthesize firstLine = _firstLine;
@synthesize image = _image;
@synthesize secondLine = _secondLine;
@synthesize thirdLine = _thirdLine;
@synthesize rightLine = _rightLine;

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
