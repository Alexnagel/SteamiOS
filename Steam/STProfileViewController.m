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
#import "STAchievementViewController.h"

#define USER_FILE @"user.txt"

@interface STProfileViewController ()
@property (nonatomic, weak) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) STUser *user;
@property (nonatomic, strong) STApiService *apiService;

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSString *userFile;

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSTimer *updateTimer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateData;
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
    
    // Set the UserDefaults and load the UserID
    _defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [_defaults stringForKey:@"userID"];
    // Init the api service with userID
    _apiService = [[STApiService alloc] initWithUserID:userID];
    
    // Run Activity Indicator on main thread
    // Loading is happening so nothing to do in UI anyways
    UIActivityIndicatorView *iView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
    [iView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [iView startAnimating];
    [self.view addSubview:iView];
    
    //Run the init of the user in seperate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initUser];
        
        [iView stopAnimating];
        [iView removeFromSuperview];
    });
}

#pragma mark - Update Functions
- (void)startUpdateTimer
{
    // Start The update timer
    // run every 5min
    [NSTimer scheduledTimerWithTimeInterval:300
                                     target:self
                                   selector:@selector(updateData:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateData:(NSTimer *)timer
{
    // Run in seperate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Update the user data
        [self setUser:[_apiService getUserFromJSON]];
        
        // Update recently played games data
        [_user updateRecentGames:[_apiService getRecentPlayedGamesFromJSON]];
        [self reloadTableAsync];
        
        // Save the updated data
        [NSKeyedArchiver archiveRootObject:_user toFile:_userFile];
        [_defaults setObject:@"YES" forKey:@"encodedUser"];
        [_defaults synchronize];
    });
}

#pragma mark - User Functions
// Init the user from decoder or from JSON and the encode
- (void)initUser
{
    // Check if user has been saved already
    // if so load from memory
    if ([_defaults objectForKey:@"encodedUser"] != nil) {
        _user = (STUser *)[NSKeyedUnarchiver unarchiveObjectWithFile:_userFile];
        [self reloadTableAsync];
        
    } else {
        _user = [_apiService getUserFromJSON];
        
        // Save User
        // Use async to unload main thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_user updateRecentGames:[_apiService getRecentPlayedGamesFromJSON]];
            [self reloadTableAsync];
            
            [NSKeyedArchiver archiveRootObject:_user toFile:_userFile];
            [_defaults setObject:@"YES" forKey:@"encodedUser"];
            [_defaults synchronize];
        });
    }
    
    // Set the UI
    [self setUserItems];
}

- (void)setUserItems
{
    _usernameLabel.text = _user.playerName;
    _lastSeenLabel.text = [[NSString alloc] initWithFormat:@"Last seen: %@",_user.lastLogOff];
    
    [self loadImageAsync:_userImage WithImage:_user.avatar];
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

#pragma Game Table functions
- (void)reloadTableAsync
{
    // Reload table Async, also for speed
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gamesTable reloadData];
    });
}

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
    
    STUserGame *game = (STUserGame *)[_user.recentGames objectAtIndex:indexPath.row];
    cell.textLabel.text         = game.gameName;
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%@ uren gespeeld", game.playtimeTwoWeeks];
    [self loadImageAsync:cell.imageView WithImage:game.imgIcon];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STUserGame *game = (STUserGame *)[_user.recentGames objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"AchievementView" sender:game];
}

#pragma mark - Games Functions
- (void)saveAchievementsForGames
{
    
}

#pragma mark - NavigationBar

- (IBAction)updateDataClick:(id)sender {
    [self updateData:_updateTimer];
}

- (IBAction)logoutUser:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userID"];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    STAchievementViewController *controller = (STAchievementViewController *)[segue destinationViewController];
    STUserGame *game = (STUserGame *)sender;
    controller.game = game;
}

@end
