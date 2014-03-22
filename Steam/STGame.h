//
//  STGame.h
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STGame : NSObject <NSCoding>

- (id)initWithDictionary:(NSDictionary *)jsonData;

@property (readonly) NSString *gameID;
@property (readonly) NSString *gameName;
@property (readonly) NSString *playtimeTwoWeeks;
@property (readonly) NSString *playtimeForever;
@property (readonly) NSString *imgLogoURL;
@property (readonly) UIImage  *imgLogo;
@property (readonly) NSDate   *lastUpdated;

@end
