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
    NSMutableArray *_achievements;
    NSInteger *_achievementCount;
}

- (id)initWithDictionary:(NSDictionary *)jsonData;

@property (readonly) NSString *gameID;
@property (readonly) NSString *gameName;
@property (readonly) UIImage  *imgLogo;
@property (readonly) UIImage  *imgIcon;
@property (readonly) NSDate   *lastUpdated;

@property (readonly) NSMutableArray *achievements;
@property (readonly) NSInteger *achievementCount;
@end
