//
//  STAchievementViewController.m
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STAchievementViewController.h"
#import "STGame.h"

@interface STAchievementViewController ()

@end

@implementation STAchievementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    [self.nameLabel setText:_game.gameName];
    [self.logoView setImage:_game.imgLogo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = NO;
}


@end
