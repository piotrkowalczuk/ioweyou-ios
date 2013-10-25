//
//  EntryManager.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "Entry.h"
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

- (void)fetchAllsuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [userManager getAuth];
    NSMutableString *getPath = [NSMutableString stringWithString:@"/entries"];
    
    [[IOUManager sharedManager] getPath:getPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

- (void)fetchOneById:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [userManager getAuth];
    NSMutableString *getPath = [NSMutableString stringWithString:@"/entry/"];
    [getPath appendString:[entryId stringValue]];
    
    [[IOUManager sharedManager] getPath:getPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

- (void)acceptEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = [userManager getAuth];
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
    NSDictionary *params = [userManager getAuth];
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
    NSDictionary *params = [userManager getAuth];
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


- (void)modifyEntry:(NSDictionary *)entry success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[userManager getAuth]];
    [params addEntriesFromDictionary:entry];
    
    NSMutableString *modifyPath = [NSMutableString stringWithString:@"/entry/"];
    [modifyPath appendString:[[entry valueForKey:@"id"] stringValue]];
    
    [[IOUManager sharedManager] postPath:modifyPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

- (void)createEntry:(NSDictionary *)entry success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[userManager getAuth]];
    [params addEntriesFromDictionary:entry];
    
    NSMutableString *createPath = [NSMutableString stringWithString:@"/entry/"];
    
    [[IOUManager sharedManager] putPath:createPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _successHandler = [success copy];
        _successHandler(responseObject);
        _successHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _failureHandler = [failure copy];
        _failureHandler(error);
        _failureHandler = nil;
    }];
}

- (void)fetchSummaryWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[userManager getAuth]];    
    NSMutableString *getPath = [NSMutableString stringWithString:@"/entries/summary"];
    
    [[IOUManager sharedManager] getPath:getPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
