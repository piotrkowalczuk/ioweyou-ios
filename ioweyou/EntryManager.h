//
//  EntryManager.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryManager : NSObject

- (void)acceptEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)rejectEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)deleteEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
