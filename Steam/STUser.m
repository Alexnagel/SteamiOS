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

@implementation STUser

- (id)initWithJSONDictionary:(NSDictionary *)json
{
    if (self = [super init]) {
        _steamID    = json[@"steamid"];
        _playerName = json[@"personaname"];
        _lastLogOff = [self convertLastLogOff:json[@"lastlogoff"]];
        _avatar     = [self getImageFromURL:json[@"avatarfull"]];
        
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
        _steamID        = [decoder decodeObjectForKey:STEAMID];
        _playerName     = [decoder decodeObjectForKey:NAME];
        _lastLogOff     = [decoder decodeObjectForKey:LASTSEEN];
        _avatar         = [decoder decodeObjectForKey:AVATAR];
        _lastUpdated    = [decoder decodeObjectForKey:LASTUPDATE];
    }
    return self;
}

- (UIImage *)getImageFromURL:(NSString *)imageURL {
    UIImage *result;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    result       = [UIImage imageWithData:data];
    
    return result;
}

- (NSString *)convertLastLogOff:(NSString *)lastLogOff {
    NSString *lastLogOffStr;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[lastLogOff longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM, HH:mm"];
    lastLogOffStr = [formatter stringFromDate:date];
    
    return lastLogOffStr;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.steamID forKey:STEAMID];
    [encoder encodeObject:self.playerName forKey:NAME];
    [encoder encodeObject:self.lastLogOff forKey:LASTSEEN];
    [encoder encodeObject:self.avatar forKey:AVATAR];
    [encoder encodeObject:self.lastUpdated forKey:LASTUPDATE];
}

@end