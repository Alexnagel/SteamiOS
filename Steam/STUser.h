//
//  STUser.h
//  Steam
//
//  Created by Alex Nagelkerke on 19-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUser : NSObject <NSCoding>

- (id)initWithJSONDictionary:(NSDictionary *)json;
- (void)updateRecentGames:(NSMutableArray *)games;

@property (readonly) NSString *steamID;
@property (readonly) NSString *playerName;
@property (readonly) UIImage  *avatar;
@property (readonly) NSString *avatarUrl;
@property (readonly) NSString *lastLogOff;
@property (readonly) NSDate   *lastUpdated;

@property (readonly) NSMutableArray *recentGames;

@end
