//
//  STUser.m
//  Steam
//
//  Created by Alex Nagelkerke on 19-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STUser.h"

#define STEAMID @"steamid"
#define NAME @"playername"
#define LASTSEEN @"lastseen"
#define AVATAR @"avatar"
#define LASTUPDATE @"lastupdated"
#define RECENTGAMES @"recentgames"
#define RECENTHOURS @"recenthours"
#define TOTALHOURS @"totalhours"

@implementation STUser

- (id)initWithJSONDictionary:(NSDictionary *)json
{
    if (self = [super init]) {
        // Init standard things
        _steamID     = json[@"steamid"];
        _playerName  = json[@"personaname"];
        _lastLogOff  = [self convertLastLogOff:json[@"lastlogoff"]];
        _avatar      = [self getImageFromURL:json[@"avatarfull"]];
        _onlineState = json[@"personastate"];
        
        // Capitalize first letter
        _playerName = [[[_playerName substringToIndex:1] uppercaseString]
                       stringByAppendingString:[_playerName substringFromIndex:1]];
        
        // Save last updated
        _lastUpdated = [[NSDate alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        // init all from decoder
        _steamID        = [decoder decodeObjectForKey:STEAMID];
        _playerName     = [decoder decodeObjectForKey:NAME];
        _lastLogOff     = [decoder decodeObjectForKey:LASTSEEN];
        _avatar         = [decoder decodeObjectForKey:AVATAR];
        _recentGames    = [decoder decodeObjectForKey:RECENTGAMES];
        _recentHours    = [decoder decodeObjectForKey:RECENTHOURS];
        _totalHours     = [decoder decodeObjectForKey:TOTALHOURS];
        _lastUpdated    = [decoder decodeObjectForKey:LASTUPDATE];
    }
    return self;
}

- (UIImage *)getImageFromURL:(NSString *)imageURL {
    UIImage *result;
    
    // Get the image from the URL
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    result       = [UIImage imageWithData:data];
    
    return result;
}

- (NSString *)convertLastLogOff:(NSString *)lastLogOff {
    NSString *lastLogOffStr;
    
    // Init date with the UTC timestamp
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[lastLogOff longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM HH:mm"];
    
    // Format the string to human readable string
    lastLogOffStr = [formatter stringFromDate:date];
    
    return lastLogOffStr;
}

- (void)updateRecentGames:(NSMutableArray *)games
{
    // Replace the games array
    _recentGames = games;
    
}

- (void)updateHoursPlayed{
    float sumRecent = 0;
    float sumTotal = 0;
    for (STUserGame * g in _recentGames)
    {
        sumRecent += [g.playtimeTwoWeeks floatValue];
        sumTotal += [g.playtimeForever floatValue];
    }
    _recentHours = [NSString stringWithFormat:@"%.1f", sumRecent];
    _totalHours = [NSString stringWithFormat:@"%.1f", sumTotal];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.steamID forKey:STEAMID];
    [encoder encodeObject:self.playerName forKey:NAME];
    [encoder encodeObject:self.lastLogOff forKey:LASTSEEN];
    [encoder encodeObject:self.avatar forKey:AVATAR];
    [encoder encodeObject:self.recentGames forKey:RECENTGAMES];
    [encoder encodeObject:self.recentHours forKey:RECENTHOURS];
    [encoder encodeObject:self.totalHours forKey:TOTALHOURS];
    [encoder encodeObject:self.lastUpdated forKey:LASTUPDATE];
}

@end