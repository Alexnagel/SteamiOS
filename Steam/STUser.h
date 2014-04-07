//
//  STUser.h
//  Steam
//
//  Created by Alex Nagelkerke on 19-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STUserGame.h"

@interface STUser : NSObject <NSCoding>

- (id)initWithJSONDictionary:(NSDictionary *)json;
- (void)updateRecentGames:(NSMutableArray *)games;
- (void)updateHoursPlayed;

@property (readonly) NSString *steamID;
@property (readonly) NSString *playerName;
@property (readonly) UIImage  *avatar;
@property (readonly) NSString *avatarUrl;
@property (readonly) NSString *lastLogOff;
@property (readonly) NSDate   *lastUpdated;
@property (readonly) NSString *onlineState;
@property (readonly) NSString *recentHours;
@property (readonly) NSString *totalHours;
@property (readonly) NSMutableArray *recentGames;

@end
