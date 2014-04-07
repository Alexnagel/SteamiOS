//
//  STAchievement.m
//  Steam
//
//  Created by Alex Nagelkerke on 23-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STAchievement.h"

#define APINAME @"apiname"
#define NAME @"name"
#define DESCRIPTION @"description"
#define ISHIDDEN @"hidden"
#define ICONACH @"iconachieved"
#define ICON @"icon"
#define USERACHIEVED @"userachieved"
#define GLOBALPERC @"globalpercentage"

@interface STAchievement()
@property (nonatomic, readwrite) NSString *userAchieved;
@property (nonatomic, readwrite) NSString *globalPercentage;
@end

@implementation STAchievement

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _apiName        = dictionary[@"name"];
        _name           = dictionary[@"displayName"];
        _isHidden       = dictionary[@"hidden"];
        _description    = (dictionary[@"description"] == nil) ? @"Secret" : dictionary[@"description"];
        _iconAchieved   = [self getImageFromURL:dictionary[@"icon"]];
        _icon           = [self getImageFromURL:dictionary[@"icongray"]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _apiName            = [decoder decodeObjectForKey:APINAME];
        _name               = [decoder decodeObjectForKey:NAME];
        _isHidden           = [decoder decodeObjectForKey:ISHIDDEN];
        _iconAchieved       = [decoder decodeObjectForKey:ICONACH];
        _icon               = [decoder decodeObjectForKey:ICON];
        _userAchieved       = [decoder decodeObjectForKey:USERACHIEVED];
        _description        = [decoder decodeObjectForKey:DESCRIPTION];
        _globalPercentage   = [decoder decodeObjectForKey:GLOBALPERC];
        
        if (_userAchieved == nil)
            _userAchieved = @"no";
    }
    return self;
}

- (void)setUserAchieved:(NSString *)userAchieved
{
    _userAchieved = userAchieved;
}

- (void)setGlobalPercentage:(NSString *)globalPercentage
{
    _globalPercentage = globalPercentage;
}

- (UIImage *)getImageFromURL:(NSString *)imageURL {
    UIImage *result;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    result       = [UIImage imageWithData:data];
    
    return result;
}

- (UIImage *)getAchievementIcon
{
    if ([_userAchieved  isEqual:@"yes"])
        return _iconAchieved;
    else
        return _icon;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.apiName forKey:APINAME];
    [encoder encodeObject:self.name forKey:NAME];
    [encoder encodeObject:self.isHidden forKey:ISHIDDEN];
    [encoder encodeObject:self.iconAchieved forKey:ICONACH];
    [encoder encodeObject:self.icon forKey:ICON];
    [encoder encodeObject:self.userAchieved forKey:USERACHIEVED];
    [encoder encodeObject:self.description forKey:DESCRIPTION];
    [encoder encodeObject:self.globalPercentage forKey:GLOBALPERC];
}

@end
