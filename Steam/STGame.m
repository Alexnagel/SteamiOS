//
//  STGame.m
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STGame.h"
#import "STApiService.h"

#define GAMEID @"gameid"
#define NAME   @"gamename"
#define PLAYFOREVER @"playtimeforever"
#define PLAYTWOWEEKS @"playtimetwoweeks"
#define GAMELOGO @"gamelogo"
#define LASTUPDATE @"lastupdated"
#define GAMEICON @"gameicon"
#define ACHIEVEMENTCOUNT @"achievementcount"
#define HASACHIEVEMENTS @"hasachievements"

#define IMAGEURL @"http://media.steampowered.com/steamcommunity/public/images/apps/%1$@/%2$@.jpg"

@interface STGame()
@property (nonatomic, strong) NSString *achievementStr;
@end

@implementation STGame
@synthesize gameID           = _gameID;
@synthesize gameName         = _gameName;
@synthesize imgLogo          = _imgLogo;
@synthesize imgIcon          = _imgIcon;
@synthesize achievements     = _achievements;
@synthesize achievementCount = _achievementCount;
@synthesize lastUpdated      = _lastUpdated;
@synthesize hasAchievements  = _hasAchievements;

- (id)initWithDictionary:(NSDictionary *)jsonData
{
    if(self = [super init])
    {
        _gameID             = jsonData[@"appid"];
        _gameName           = jsonData[@"name"];
        _imgLogo            = [self getImageFromURL:jsonData[@"img_logo_url"]];
        _imgIcon            = [self getImageFromURL:jsonData[@"img_icon_url"]];
        _lastUpdated        = [[NSDate alloc]init];
        
        // Set the string for the achievements object key (Encoding)
        _achievementStr     = [NSString stringWithFormat:@"achievements_%@",_gameID];
        _hasAchievements    = YES;
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
        
        _achievementStr     = [NSString stringWithFormat:@"achievements_%@",_gameID];
        _achievements       = [decoder decodeObjectForKey:_achievementStr];
        _achievementCount   = [decoder decodeObjectForKey:ACHIEVEMENTCOUNT];
        _hasAchievements    = (BOOL)[decoder decodeObjectForKey:HASACHIEVEMENTS];
    }
    return self;
}

- (UIImage *)getImageFromURL:(NSString *)imageHash
{
    UIImage *result;
    NSString *imageURL = [NSString stringWithFormat:IMAGEURL, _gameID, imageHash];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    result       = [UIImage imageWithData:data];
    
    if (result == nil) {
        result = [self getPlaceholderImage];
    }
    
    return result;
}

- (UIImage *)getPlaceholderImage
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *gray = [UIColor grayColor];
    CGContextSetFillColorWithColor(context, [gray CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setGameAchievements
{
    // Get the Achievements for a game
    // do it async to unload main ui
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STApiService *apiService = [[STApiService alloc] init];
        _achievements = [apiService getGameAchievementsFromJSON:_gameID];
        _achievementCount = [NSString stringWithFormat:@"%lu",(unsigned long)[_achievements count]];
    });
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.gameID forKey:GAMEID];
    [encoder encodeObject:self.gameName forKey:NAME];
    [encoder encodeObject:self.imgLogo forKey:GAMELOGO];
    [encoder encodeObject:self.imgIcon forKey:GAMEICON];
    [encoder encodeObject:self.lastUpdated forKey:LASTUPDATE];
    [encoder encodeObject:self.achievements forKey:_achievementStr];
    [encoder encodeObject:self.achievementCount forKey:ACHIEVEMENTCOUNT];
}

@end
