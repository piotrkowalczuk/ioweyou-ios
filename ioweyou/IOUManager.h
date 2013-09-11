//
//  IOUManager.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 16.08.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFHTTPClient.h"

@interface IOUManager : AFHTTPClient

- (void)setAuthToken: (NSString *)authToken;

+ (IOUManager *)sharedManager;

@end
