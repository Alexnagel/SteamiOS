//
//  STUserGame.m
//  Steam
//
//  Created by Alex Nagelkerke on 23-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STUserGame.h"

#define PLAYFOREVER @"playtimeforever"
#define PLAYTWOWEEKS @"playtimetwoweeks"

@implementation STUserGame

- (id)initWithDictionary:(NSDictionary *)jsonData
{
    if(self = [super initWithDictionary:jsonData])
    {
        _playtimeForever    = [self minutesToHours:jsonData[@"playtime_forever"]];
        _playtimeTwoWeeks   = [self minutesToHours:jsonData[@"playtime_2weeks"]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super initWithCoder:decoder])
    {
        _playtimeForever    = [decoder decodeObjectForKey:PLAYFOREVER];
        _playtimeTwoWeeks   = [decoder decodeObjectForKey:PLAYTWOWEEKS];
    }
    return self;
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
