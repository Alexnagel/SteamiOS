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
#define USERACHIEVED @"userachieved"

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
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super initWithCoder:decoder])
    {
        _playtimeForever    = [decoder decodeObjectForKey:PLAYFOREVER];
        _playtimeTwoWeeks   = [decoder decodeObjectForKey:PLAYTWOWEEKS];
        _userAchievements   = [decoder decodeObjectForKey:USERACHIEVED];
    }
    return self;
}

- (BOOL)checkAchievements
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the current date
    NSDate *currentDate = [[NSDate alloc] init];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:currentDate toDate:_lastUpdated options:0];
    
    NSLog(@"%d", ([breakdownInfo minute] > 30));
    if ( _achievements == nil || (([breakdownInfo minute] > 30) == 1)) {
        [self setGameAchievements];
        return YES;
    }
    return NO;
}

- (void)setGameAchievements
{
    STApiService *apiService = [[STApiService alloc] initWithUserID:_userID];
        
    _achievements = [apiService getGameAchievementsFromJSON:_gameID];
    _achievementCount = [NSString stringWithFormat:@"%d",[_achievements count]];
    
    _userAchievements = [apiService getUserGameAchievementsFromJSON:_achievements ForApp:_gameID];
    _lastUpdated = [[NSDate alloc] init];
}

- (NSString *)achievementsAchieved
{
    return [NSString stringWithFormat:@"%1$@/%2$@ Achievements", _userAchievements, _achievementCount];
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
    [encoder encodeObject:self.userAchievements forKey:USERACHIEVED];
}

@end
