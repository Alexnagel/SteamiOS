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
    [self.totalPlayedLabel setText:[NSString stringWithFormat:@"%@ hrs on record", _game.playtimeForever]];
    
    if (!_game.hasAchievements) {
        UIView *emptyView = [[UIView alloc] init];
        [emptyView setFrame:CGRectMake(0,
                                       0,
                                       _achievementTable.frame.size.width,
                                       _achievementTable.frame.size.height)];
        
        UILabel *emptyLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 43)];
        emptyLabel.font          = [UIFont systemFontOfSize:13];
        emptyLabel.text          = @"This game has no achievements...";
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        [emptyLabel setCenter:emptyView.center];
        [emptyView addSubview:emptyLabel];
        
        self.achievementTable.backgroundView = emptyView;
        self.achievementTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else{
        // Sort achievements on rarity
        _achievementArray = [_achievementArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            double first = [[(STAchievement*)a globalPercentage] doubleValue];
            double second = [[(STAchievement*)b globalPercentage] doubleValue];
            return (second > first);
        }];
    }
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
    cell.descriptionLabel.text = achievement.description;
    cell.percentageLabel.text = [NSString stringWithFormat:@"%@%% of all players",achievement.globalPercentage];
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
