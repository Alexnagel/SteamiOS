//
//  STProfileViewController.h
//  Steam
//
//  Created by Alex Nagelkerke on 21/03/14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
