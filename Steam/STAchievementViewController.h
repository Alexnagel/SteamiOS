//
//  STAchievementViewController.h
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STGame.h"

@interface STAchievementViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) STGame *game;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;
@end
