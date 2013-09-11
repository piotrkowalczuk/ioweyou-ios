//
//  IOUApi.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 15.08.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOUAPI : NSObject

@property (nonatomic, retain) NSString *baseUrl;

- (id) generateUrlFromQuery: (NSString *)query;
- (id) fetchAllEntriesByUserId: (int)userId;

@end


