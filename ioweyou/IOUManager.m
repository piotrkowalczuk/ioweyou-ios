//
//  IOUManager.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 16.08.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "IOUManager.h"
#import "AFNetworking/AFJSONRequestOperation.h"
#import "AFNetworking/AFNetworkActivityIndicatorManager.h"

@implementation IOUManager : AFHTTPClient

#pragma mark - Methods

- (void)setAuthToken: (NSString *)authToken
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithToken:authToken];
}

#pragma mark - Initialiation

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if(!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return self;
}

#pragma mark - Singleton Methods

+ (IOUManager *)sharedManager
{
    static dispatch_once_t pred;
    static IOUManager *_sharedManager = nil;
    
    dispatch_once(&pred, ^{ _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.103:8000"]]; });
    return _sharedManager;
}

@end
