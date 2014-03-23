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
#define GAMEICON @"gameicon"

#define IMAGEURL @"http://media.steampowered.com/steamcommunity/public/images/apps/%1$@/%2$@.jpg"


@implementation STGame
@synthesize gameID           = _gameID;
@synthesize gameName         = _gameName;
@synthesize imgLogo          = _imgLogo;
@synthesize imgIcon          = _imgIcon;
@synthesize achievements     = _achievements;
@synthesize achievementCount = _achievementCount;

- (id)initWithDictionary:(NSDictionary *)jsonData
{
    if(self = [super init])
    {
        _gameID             = jsonData[@"appid"];
        _gameName           = jsonData[@"name"];
        _imgLogo            = [self getImageFromURL:jsonData[@"img_logo_url"]];
        _imgIcon            = [self getImageFromURL:jsonData[@"img_icon_url"]];
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
        _imgLogo            = [decoder decodeObjectForKey:GAMELOGO];
        _imgIcon            = [decoder decodeObjectForKey:GAMEICON];
        _lastUpdated        = [decoder decodeObjectForKey:LASTUPDATE];
        
        NSString *achievementStr = [NSString stringWithFormat:@"achievements_%@",_gameID];
        _achievements            = [decoder decodeObjectForKey:achievementStr];
    }
    return self;
}

- (UIImage *)getImageFromURL:(NSString *)imageHash
{
    UIImage *result;
    NSString *imageURL = [NSString stringWithFormat:IMAGEURL, _gameID, imageHash];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    result       = [UIImage imageWithData:data];
    
    return result;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.gameID forKey:GAMEID];
    [encoder encodeObject:self.gameName forKey:NAME];
    [encoder encodeObject:self.imgLogo forKey:GAMELOGO];
    [encoder encodeObject:self.imgLogo forKey:GAMEICON];
    [encoder encodeObject:self.lastUpdated forKey:LASTUPDATE];
}

@end
