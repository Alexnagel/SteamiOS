//
//  STAchievementCell.h
//  Steam
//
//  Created by Alex Nagelkerke on 23-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAchievementCell : UITableViewCell
{
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *percentageLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *percentageLabel;

@end
