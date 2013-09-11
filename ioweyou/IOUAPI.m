//
//  IOUApi.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 15.08.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "IOUAPI.h"
#import <AFNetworking/AFNetworking.h>

@implementation IOUAPI

@synthesize baseUrl;

- (id) init 
{
    self = [super init];
    if (self) {
        NSString *baseUrl = @"http://ioweyou.local.tld:8000";
    }
    
    return self;
}

- (id) generateUrlFromQuery: (NSString *)query
{
    NSString *tmpString = [NSString stringWithFormat:@"%@%@", self.baseUrl, query];
    NSURL *url = [NSURL URLWithString:tmpString];
    return url;
}

- (id) loginWith:(NSString *)facebookId and:(NSString *)token
{
    __block NSDictionary *result;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self generateUrlFromQuery:@"/login"]];
    
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {

    } failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
        NSLog(@"Received an HTTP %d", response.statusCode);
        NSLog(@"The error was: %@", error);
    }];
    
    [operation start];
}

@end
