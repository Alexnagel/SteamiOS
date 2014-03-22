//
//  STGame.m
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STGame.h"

#define GAMEID @"gameid"
#define NAME   @"gamename"
#define PLAYFOREVER @"playtimeforever"
#define PLAYTWOWEEKS @"playtimetwoweeks"
#define GAMELOGO @"gamelogo"
#define LASTUPDATE @"lastupdated"

#define IMAGEURL @"http://media.steampowered.com/steamcommunity/public/images/apps/%@/%@.jpg"


@implementation STGame

- (id)initWithDictionary:(NSDictionary *)jsonData
{
    if(self = [super init])
    {
        _gameID             = jsonData[@"appid"];
        _gameName           = jsonData[@"name"];
        _playtimeForever    = [self minutesToHours:jsonData[@"playtime_forever"]];
        _playtimeTwoWeeks   = [self minutesToHours:jsonData[@"playtime_2weeks"]];
        _imgLogo            = [self getImageFromURL:jsonData[@"img_logo_url"]];
        _lastUpdated        = [[NSDate alloc]init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        _gameID             = [decoder decodeObjectForKey:GAMEID];
        _gameName           = [decoder decodeObjectForKey:NAME];
        _playtimeForever    = [decoder decodeObjectForKey:PLAYFOREVER];
        _playtimeTwoWeeks   = [decoder decodeObjectForKey:PLAYTWOWEEKS];
        _imgLogo            = [decoder decodeObjectForKey:GAMELOGO];
        _lastUpdated        = [decoder decodeObjectForKey:LASTUPDATE];
    }
    return self;
}

- (NSString *)minutesToHours:(NSString *)minutes
{
    double uur = [minutes doubleValue] / 60;
    return [NSString stringWithFormat:@"%.2f", uur];
}

- (UIImage *)getImageFromURL:(NSString *)imageHash
{
    UIImage *result;
    NSString *imageURL = [NSString stringWithFormat:IMAGEURL, _gameID, _imgLogoURL];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    result       = [UIImage imageWithData:data];
    
    return result;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.gameID forKey:GAMEID];
    [encoder encodeObject:self.gameName forKey:NAME];
    [encoder encodeObject:self.playtimeForever forKey:PLAYFOREVER];
    [encoder encodeObject:self.playtimeTwoWeeks forKey:PLAYTWOWEEKS];
    [encoder encodeObject:self.imgLogo forKey:GAMELOGO];
    [encoder encodeObject:self.lastUpdated forKey:LASTUPDATE];
}

@end
