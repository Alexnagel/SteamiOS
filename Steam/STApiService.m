//
//  STApiService.m
//  Steam
//
//  Created by Alex Nagelkerke on 21/03/14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STApiService.h"

#define userApiString @"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=E889B9429FF4CBE7247FA5EBA9B60E60&steamids=%@"
#define recentGamesApiString @"http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key=E889B9429FF4CBE7247FA5EBA9B60E60&steamid=%@"

#pragma mark - Achievement URLS
#define gameAchievements @"http://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2?key=E889B9429FF4CBE7247FA5EBA9B60E60&appid=%@"
#define globalPrecentage @"http://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/?gameid=%@"
#define userAchievements @"http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?key=E889B9429FF4CBE7247FA5EBA9B60E60&appid=%1$@&steamid=%2$@"

@interface STApiService ()

@property (nonatomic, strong) NSURL *userApiURL;
@property (nonatomic, strong) NSURL *recentGamesApiURL;
@property (nonatomic) NSString *userID;

@end

@implementation STApiService

- (id) initWithUserID:(NSString *)userID
{
    if (self = [super init]) {
        // Init userID
        [self setUserID:userID];
        
        // Init user URL
        NSString *userURL = [NSString stringWithFormat:userApiString, userID];
        // Init recent games URL
        NSString *recentGamesURL = [NSString stringWithFormat:recentGamesApiString,userID];
        
        [self setUserApiURL:[NSURL URLWithString:userURL]];
        [self setRecentGamesApiURL:[NSURL URLWithString:recentGamesURL]];
    }
    return self;
}

- (STUser *) getUserFromJSON
{
    NSDictionary *jsonData = nil;
    STUser *user           = Nil;
    
    jsonData = [self callApiURL:_userApiURL];
    if(jsonData != nil) {
        NSDictionary *resJSON = jsonData[@"response"][@"players"][0];
        user = [[STUser alloc] initWithJSONDictionary:resJSON];
    }
    
    return user;
}

- (NSMutableArray *)getGamesFromJSON
{
    NSDictionary *jsonData    = nil;
    NSMutableArray *gamesArray = [[NSMutableArray alloc] init];
    
    jsonData = [self callApiURL:_recentGamesApiURL];
    if(jsonData != nil) {
        for (NSDictionary *game in jsonData[@"response"][@"games"]) {
            STGame *sGame = [[STGame alloc] initWithDictionary:game];
            [gamesArray addObject:sGame];
        }
    }
    return gamesArray;
}

- (NSMutableDictionary *)getGameAchievementsFromJSON:(NSString *)appID
{
    NSDictionary *jsonData = nil;
    NSMutableDictionary *achievementDict= [[NSMutableDictionary alloc] init];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:gameAchievements, appID]];
    jsonData = [self callApiURL:url];
    if(jsonData != nil) {
        for (NSDictionary *achievement in jsonData[@"game"][@"availableGameStats"][@"achievements"]) {
            STAchievement *ach = [[STAchievement alloc] initWithDictionary:achievement];
            
            [achievementDict setObject:ach forKey:achievement[@"name"]];
        }
    }
    
    return [self setGlobalPercentages:achievementDict ForApp:appID];
}

- (NSMutableDictionary *)setGlobalPercentages:(NSMutableDictionary *)achievements
                                       ForApp:(NSString *)appID
{
    NSDictionary *jsonData = nil;
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:globalPrecentage, appID]];
    jsonData = [self callApiURL:url];
    if(jsonData != nil) {
        for (NSDictionary *achievement in jsonData[@"achievementpercentages"][@"achievements"]) {
            STAchievement *ach = [achievements objectForKey:achievement[@"name"]];
            
            NSString *percent = achievement[@"percent"];
            [ach setGlobalPercentage:[NSString stringWithFormat:@"%.1f",[percent doubleValue]]];
        }
    }
    
    return achievements;
}

- (NSString *)getUserGameAchievementsFromJSON:(NSMutableDictionary *)achievements
                                ForApp:(NSString *)appID
{
    NSDictionary *jsonData = nil;
    int achievedAmount = 0;
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:userAchievements, appID, _userID]];
    jsonData = [self callApiURL:url];
    if(jsonData != nil) {
        for (NSDictionary *achievement in jsonData[@"playerstats"][@"achievements"]) {
            STAchievement *ach = [achievements objectForKey:achievement[@"apiname"]];
            
            NSString *achieved = achievement[@"achieved"];
            if ([achieved intValue] == 1) {
                achieved = @"yes";
                achievedAmount++;
            } else
                achieved = @"no";
            
            [ach setUserAchieved:achieved];
        }
    }
    return [NSString stringWithFormat:@"%d", achievedAmount];
}

- (NSMutableArray *)getRecentPlayedGamesFromJSON
{
    NSDictionary *jsonData    = nil;
    NSMutableArray *gamesArray = [[NSMutableArray alloc] init];
    
    jsonData = [self callApiURL:_recentGamesApiURL];
    if(jsonData != nil) {
        for (NSDictionary *game in jsonData[@"response"][@"games"]) {
            STUserGame *sGame = [[STUserGame alloc] initWithDictionary:game AndUserID:_userID];
            [gamesArray addObject:sGame];
        }
    }
    return gamesArray;
}


- (NSDictionary *)callApiURL:(NSURL *)apiURL
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data;
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error == nil) {
        if(data != nil) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if(error == nil) {
                return jsonDic;
            } else {
                return nil;
            }
        }
    }
    return nil;
}

@end