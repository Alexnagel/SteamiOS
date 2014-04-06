//
//  STAchievementViewController.m
//  Steam
//
//  Created by Alex Nagelkerke on 22-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STAchievementViewController.h"

@interface STAchievementViewController()
@property (strong, nonatomic) IBOutlet UITableView *achievementTable;

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
    [self.achievementLabel setText:_game.achievementsAchieved];
    [self.totalPlayedLabel setText:[NSString stringWithFormat:@"%@ uren totaal", _game.playtimeForever]];
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

#pragma mark - TableView Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_game.achievements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AchievementCell";
    STAchievementCell *cell       = [self.achievementTable dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[STAchievementCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    STAchievement *achievement = [_achievementArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = achievement.name;
    cell.percentageLabel.text = [NSString stringWithFormat:@"%@%% van alle spelers",achievement.globalPercentage];
    [self loadImageAsync:cell.iconView WithImage:[achievement getAchievementIcon]];

    return cell;
}

// Load images on seperate UI thread
// Makes them load waaay faster
- (void)loadImageAsync:(UIImageView*)view
             WithImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        view.image    = image;
    });
}

@end
