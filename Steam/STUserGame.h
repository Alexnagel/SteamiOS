//
//  STUserGame.h
//  Steam
//
//  Created by Alex Nagelkerke on 23-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STGame.h"

@interface STUserGame : STGame <NSCoding>

@property (readonly) NSString *playtimeTwoWeeks;
@property (readonly) NSString *playtimeForever;
@property (nonatomic, readonly) NSString *userAchievements;
@property (readonly) NSString *userID;

- (id)initWithDictionary:(NSDictionary *)jsonData
               AndUserID:(NSString *)userID;
- (NSString *)achievementsAchieved;
- (void)setGameAchievements;
- (BOOL)checkAchievements;
@end
