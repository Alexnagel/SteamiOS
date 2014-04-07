//
//  STDataService.h
//  Steam
//
//  Created by Alex Nagelkerke on 06-04-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STUser.h"

@interface STDataService : NSObject

- (void)saveUser:(STUser *)user;
- (STUser *)getUserFromUnarchiver;
- (void)logoutUser;
@end
