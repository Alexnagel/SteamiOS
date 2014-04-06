//
//  STAchievementViewController.h
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUserGame.h"
#import "STAchievementCell.h"
#import "STAchievement.h"

@interface STAchievementViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) STUserGame *game;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;
@property (nonatomic, strong) NSArray *achievementArray;
@property (strong, nonatomic) IBOutlet UILabel *totalPlayedLabel;
@end
