//
//  STProfileViewController.h
//  Steam
//
//  Created by Alex Nagelkerke on 21/03/14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *recentHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHoursLabel;
@property (weak, nonatomic) IBOutlet UITableView *gamesTable;

@end
