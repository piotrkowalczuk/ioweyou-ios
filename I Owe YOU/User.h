//
//  User.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 03.08.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * facebookId;
@property (nonatomic, strong) NSString * facebookToken;
@property (nonatomic, strong) NSString * ioweyouId;
@property (nonatomic, strong) NSString * ioweyouToken;

@end
