//
//  STUserGame.m
//  Steam
//
//  Created by Alex Nagelkerke on 23-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STUserGame.h"
#import "STApiService.h"

#define PLAYFOREVER @"playtimeforever"
#define PLAYTWOWEEKS @"playtimetwoweeks"

// Subclass of STGame
// UserGame has the user information in it too
@implementation STUserGame

- (id)initWithDictionary:(NSDictionary *)jsonData
               AndUserID:(NSString *)userID
{
    if(self = [super initWithDictionary:jsonData])
    {
        _playtimeForever    = [self minutesToHours:jsonData[@"playtime_forever"]];
        _playtimeTwoWeeks   = [self minutesToHours:jsonData[@"playtime_2weeks"]];
        _userID             = userID;
        _userAchievements   = 0;
        
        [self setGameAchievements];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super initWithCoder:decoder])
    {
        _playtimeForever    = [decoder decodeObjectForKey:PLAYFOREVER];
        _playtimeTwoWeeks   = [decoder decodeObjectForKey:PLAYTWOWEEKS];
        _userAchievements   = 0;
    }
    return self;
}

- (void)setGameAchievements
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STApiService *apiService = [[STApiService alloc] initWithUserID:_userID];
        
        _achievements = [apiService getGameAchievementsFromJSON:_gameID];
        _achievementCount = (NSInteger *)[_achievements count];
        
        _userAchievements = [apiService getUserGameAchievementsFromJSON:_achievements ForApp:_gameID];
    });
}

- (void)setUserGameAchievements:(NSString *)userID
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // STApiService *apiService = [[STApiService alloc] initWithUserID:userID];
        
//        _achievements = [apiService getUserGameAchievementsFromJSON:_achievements ForApp:_gameID UserAchievedAmount:&_userAchievements];
    });
}

- (NSString *)achievementsAchieved
{
    return [NSString stringWithFormat:@"%1$zd/%2$zd Achievements", _userAchievements, _achievementCount];
}

- (NSString *)minutesToHours:(NSString *)minutes
{
    double uur = [minutes doubleValue] / 60;
    return [NSString stringWithFormat:@"%.2f", uur];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.playtimeForever forKey:PLAYFOREVER];
    [encoder encodeObject:self.playtimeTwoWeeks forKey:PLAYTWOWEEKS];
}

@end
