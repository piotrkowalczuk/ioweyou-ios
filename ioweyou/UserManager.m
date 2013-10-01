//
//  UserManager.m
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import "UserManager.h"
#import "User.h"
#import "IOUAppDelegate.h"

@interface UserManager ()
{
    NSManagedObjectContext *context;
    void (^_successHandler)(id responseObject);
    void (^_failureHandler)(NSError *error);
}
@end

@implementation UserManager


- (id) init
{
    self = [super init];
    if (self != nil) {
        IOUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        context = [appDelegate managedObjectContext];
    }
    return self;
}

- (void) createOrUpdateUserWithUsername:(NSString *)username firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email facebookId:(NSString *)facebookId facebookToken:(NSString *)facebookToken ioweyouId:(NSString *)ioweyouId ioweyouToken:(NSString *)ioweyouToken
{
    User *user;
    
    user = [self fetchUserWithUsername:username];
    
    if(!user){
        NSLog(@"User nie istnieje, stwórz nowego.");
        user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:context];
    }
    
    [user setFacebookId:facebookId];
    [user setFacebookToken:facebookToken];
    [user setUsername:username];
    [user setFirstName:firstName];
    [user setLastName:lastName];
    [user setEmail:email];
    [user setIoweyouId:ioweyouId];
    [user setIoweyouToken:ioweyouToken];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
};


- (User *) fetchUserWithUsername:(NSString *)username
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([User class]) inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"username == %@", username];
    [request setPredicate:searchFilter];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (results == nil || [results count] == 0) {
        return NULL;
    } else {
        return [results objectAtIndex:0];
    }
}


- (User *) fetchUser
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([User class]) inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    [request setPredicate:nil];
    

    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];

    if (results == nil || [results count] == 0) {
        return NULL;
    } else {
        return [results objectAtIndex:0];
    }
}


- (NSDictionary *) getAuth
{

    User *user = [self fetchUser];
    
    if(user) {
        NSDictionary *params = @{@"uid" : [user ioweyouId], @"apiToken" : [user ioweyouToken]};
        return params;
    }
    
    return NULL;
}

@end
