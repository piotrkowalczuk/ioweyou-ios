//
//  EntryManager.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "EntryManager.h"
#import "UserManager.h"
#import "IOUManager.h"
#import "User.h"
#import "IOUAppDelegate.h"


@interface EntryManager ()
{
    NSManagedObjectContext *context;
    UserManager *userManager;
    void (^_successHandler)(id responseObject);
    void (^_failureHandler)(NSError *error);
}
@end

@implementation EntryManager

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


- (void)acceptEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [userManager getAuthParamsInManagedObjectContext:context];
    NSMutableString *postPath = [NSMutableString stringWithString:@"/entry/accept/"];
    [postPath appendString:[entryId stringValue]];
    [[IOUManager sharedManager] postPath:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

- (void)rejectEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [userManager getAuthParamsInManagedObjectContext:context];
    NSMutableString *postPath = [NSMutableString stringWithString:@"/entry/reject/"];
    [postPath appendString:[entryId stringValue]];
    [[IOUManager sharedManager] postPath:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

- (void)deleteEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [userManager getAuthParamsInManagedObjectContext:context];
    NSMutableString *deletePath = [NSMutableString stringWithString:@"/entry/"];
    [deletePath appendString:[entryId stringValue]];
    [[IOUManager sharedManager] deletePath:deletePath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
