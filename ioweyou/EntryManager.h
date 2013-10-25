//
//  EntryManager.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryManager : NSObject

- (void)fetchAllsuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)fetchOneById:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)fetchSummaryWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)acceptEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)rejectEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)deleteEntry:(NSNumber *)entryId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)modifyEntry:(NSDictionary *)entry success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)createEntry:(NSDictionary *)entry success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
