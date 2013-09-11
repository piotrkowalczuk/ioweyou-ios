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

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName             ;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSString * facebookToken;
@property (nonatomic, retain) NSString * ioweyouId;
@property (nonatomic, retain) NSString * ioweyouToken;

@end
