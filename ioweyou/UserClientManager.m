//
//  UserClientManager.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 07.12.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "UserClientManager.h"
#import "UserManager.h"
#import "IOUAppDelegate.h"
#import "IOUManager.h"

@interface UserClientManager ()
{
    NSManagedObjectContext *context;
    UserManager *userManager;
    void (^_successHandler)(id responseObject);
    void (^_failureHandler)(NSError *error);
}
@end

@implementation UserClientManager

- (id) init
{
    self = [super init];
    if (self != nil) {
        IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        context = [appDelegate managedObjectContext];
        userManager = [[UserManager alloc] init];
    }
    return self;
}


- (void) createOrUpdateWithUserClient:(NSDictionary *)userClient success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableString *path = [NSMutableString stringWithString:@"/user-client/add-or-create"];
    
    [[IOUManager sharedManager] putPath:path parameters:userClient success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

@end
