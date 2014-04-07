//
//  STDataService.m
//  Steam
//
//  Created by Alex Nagelkerke on 06-04-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STDataService.h"

#define USER_FILE @"user.txt"

@interface STDataService()

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSString       *userFile;

@end

@implementation STDataService

- (id)init
{
    if(self = [super init]) {
        // Set userFile
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _userFile = [documentsDirectory stringByAppendingPathComponent:USER_FILE];
    }
    
    return self;
}

- (void)saveUser:(STUser *)user
{
    [NSKeyedArchiver archiveRootObject:user toFile:_userFile];
    [_defaults setObject:@"YES" forKey:@"encodedUser"];
    [_defaults synchronize];
}

- (STUser *)getUserFromUnarchiver
{
    return (STUser *)[NSKeyedUnarchiver unarchiveObjectWithFile:_userFile];
}

- (void)logoutUser
{
    [_defaults removeObjectForKey:@"userID"];
    [_defaults synchronize];
}

@end
