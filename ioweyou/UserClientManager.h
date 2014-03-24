//
//  UserClientManager.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 07.12.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserClientManager : NSObject

- (void) createOrUpdateWithUserClient:(NSDictionary *)userClient success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
