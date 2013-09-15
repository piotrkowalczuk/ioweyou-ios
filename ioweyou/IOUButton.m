//
//  IOUButton.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 12.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "IOUButton.h"

@implementation IOUButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self setTitle:@"BUTTON" forState:UIControlStateNormal];
}


@end
