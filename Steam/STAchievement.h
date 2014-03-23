//
//  STAchievement.h
//  Steam
//
//  Created by Alex Nagelkerke on 23-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAchievement : NSObject <NSCoding>

- (void)setUserAchieved:(NSString *)userAchieved;
- (void)setGlobalPercentage:(NSString *)globalPercentage;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (UIImage *)getAchievementIcon;

@property (readonly) NSString *apiName;
@property (readonly) NSString *name;
@property (readonly) NSString *isHidden;
@property (readonly) UIImage  *iconAchieved;
@property (readonly) UIImage  *icon;
@property (nonatomic, readonly) NSString *userAchieved;
@property (nonatomic, readonly) NSString *globalPercentage;

@end
