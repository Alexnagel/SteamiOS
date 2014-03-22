 //
//  STApiService.m
//  Steam
//
//  Created by Alex Nagelkerke on 21/03/14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STApiService.h"
#import "STUser.h"

#define userApiString @"http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=E889B9429FF4CBE7247FA5EBA9B60E60&steamids=%@"
#define achievementsApiString @"http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?appid=%lu&key=E889B9429FF4CBE7247FA5EBA9B60E60&steamid=%@"
#define globalAchievementsApiString @"http://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/?gameid=%lu"
#define recentGamesApiString @"http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key=E889B9429FF4CBE7247FA5EBA9B60E60&steamid=%@"

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
    NSData *jsonData = nil;
    STUser *user     = Nil;
    
    jsonData = [self callApiURL:_userApiURL];
    if(jsonData != nil) {
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if(error == nil) {
            NSDictionary *resJSON = jsonDic[@"response"][@"players"][0];
            user = [[STUser alloc] initWithJSONDictionary:resJSON];
        }
    }
    
    return user;
}

- (NSMutableArray *)getGamesFromJSON
{
    NSData *jsonData    = nil;
    NSMutableArray *gamesArray = [[NSMutableArray alloc] init];
    
    jsonData = [self callApiURL:_recentGamesApiURL];
    if(jsonData != nil) {
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if(error == nil) {
            for (NSDictionary *game in jsonDic[@"response"][@"games"]) {
                STGame *sGame = [[STGame alloc] initWithDictionary:game];
                [gamesArray addObject:sGame];
            }
        }
    }
    return gamesArray;
}


- (NSData *) callApiURL:(NSURL *)apiURL
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data;
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error == nil) {
        return data;
    }
    return nil;
}

@end