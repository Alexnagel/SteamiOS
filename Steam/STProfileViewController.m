//
//  STProfileViewController.m
//  Steam
//
//  Created by Alex Nagelkerke on 21/03/14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STProfileViewController.h"
#import "STApiService.h"
#import "STUser.h"

#define USER_FILE @"user.txt"

@interface STProfileViewController ()
@property (nonatomic, weak) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) STUser *user;
@property (nonatomic, strong) STApiService *apiService;

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSString *userFile;

@property (nonatomic, strong) NSMutableArray *games;
@end

@implementation STProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set userFile
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _userFile = [documentsDirectory stringByAppendingPathComponent:USER_FILE];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [_defaults stringForKey:@"userID"];
    _apiService = [[STApiService alloc] initWithUserID:userID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIActivityIndicatorView *iView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
        [iView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [iView startAnimating];
        [self.view addSubview:iView];
        
        [self initUser];
        
        [iView stopAnimating];
        [iView removeFromSuperview];
    });
}

- (void)startUpdateTimer
{
    
}

#pragma User Functions

- (void)initUser
{
    if ([_defaults objectForKey:@"encodedUser"] != nil) {
        _user = (STUser *)[NSKeyedUnarchiver unarchiveObjectWithFile:_userFile];
        [self.gamesTable reloadData];
    } else {
        _user = [_apiService getUserFromJSON];
        
        // Save User
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_user updateRecentGames:[_apiService getGamesFromJSON]];
            [self.gamesTable reloadData];
            
            [NSKeyedArchiver archiveRootObject:_user toFile:_userFile];
            [_defaults setObject:@"YES" forKey:@"encodedUser"];
            [_defaults synchronize];
        });
    }
    
    [self setUserItems];
}

- (void)setUserItems
{
    _usernameLabel.text = _user.playerName;
    _lastSeenLabel.text = [[NSString alloc] initWithFormat:@"Last seen: %@",_user.lastLogOff];
    _userImage.image    = _user.avatar;
}

#pragma Game Table functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_user.recentGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RecentGameCell";
    UITableViewCell *cell       = [self.gamesTable dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    STGame *game = (STGame *)[_user.recentGames objectAtIndex:indexPath.row];
    cell.textLabel.text         = game.gameName;
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%@ uren gespeeld", game.playtimeTwoWeeks];
    cell.imageView.image        = game.imgLogo;
    
    return cell;
}

#pragma NavigationBar
- (IBAction)logoutUser:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userID"];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
