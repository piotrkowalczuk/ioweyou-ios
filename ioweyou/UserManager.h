//
//  UserManager.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject


- (void) createOrUpdateUserWithUsername:(NSString *)username firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email facebookId:(NSString *)facebookId facebookToken:(NSString *)facebookToken ioweyouId:(NSString *)ioweyouId ioweyouToken:(NSString *)ioweyouToken;


- (User *) fetchUserWithUsername:(NSString *)username;


- (User *) fetchUser;


- (NSDictionary *) getAuth;


@end
