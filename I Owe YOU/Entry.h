//
//  Entry.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Entry : NSManagedObject

@property (nonatomic, assign) NSInteger entry_id;
@property (nonatomic, assign) NSInteger debtor_id;
@property (nonatomic, assign) NSInteger lender_id;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSDecimal value;

@property (nonatomic, strong) NSString * debtor_first_name;
@property (nonatomic, strong) NSString * debtor_last_name;
@property (nonatomic, strong) NSString * debtor_username;
@property (nonatomic, strong) NSString * lender_first_name;
@property (nonatomic, strong) NSString * lender_last_name;
@property (nonatomic, strong) NSString * lender_username;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) NSDate * accepted_at;
@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * rejected_at;
@property (nonatomic, strong) NSDate * updated_at;

@end
