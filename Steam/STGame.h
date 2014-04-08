//
//  STGame.h
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STGame : NSObject <NSCoding> {
    @protected
    NSString *_gameID;
    NSString *_gameName;
    UIImage  *_imgLogo;
    UIImage  *_imgIcon;
    NSMutableDictionary *_achievements;
    NSString *_achievementCount;
    BOOL _hasAchievements;
    NSDate *_lastUpdated;
}

- (id)initWithDictionary:(NSDictionary *)jsonData;

@property (readonly) NSString *gameID;
@property (readonly) NSString *gameName;
@property (readonly) UIImage  *imgLogo;
@property (readonly) UIImage  *imgIcon;
@property (readonly) NSDate   *lastUpdated;

@property (readonly) NSMutableDictionary *achievements;
@property (readonly) NSString *achievementCount;
@property (readonly) BOOL hasAchievements;
@end
