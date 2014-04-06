//
//  STApiService.h
//  Steam
//
//  Created by Alex Nagelkerke on 21/03/14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STUser.h"
#import "STGame.h"
#import "STUserGame.h"
#import "STAchievement.h"

@interface STApiService : NSObject

- (id) initWithUserID:(NSString *)userID;
- (STUser *) getUserFromJSON;
- (NSMutableArray *)getGamesFromJSON;
- (NSMutableArray *)getRecentPlayedGamesFromJSON;
- (NSMutableDictionary *)getGameAchievementsFromJSON:(NSString *)appID;
- (NSString *)getUserGameAchievementsFromJSON:(NSMutableDictionary *)achievements ForApp:(NSString *)appID;
- (NSString *)getUserStatus;
@end
