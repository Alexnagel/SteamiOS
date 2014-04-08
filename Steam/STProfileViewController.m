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
#import "STDataService.h"

#define USER_FILE @"user.txt"

@interface STProfileViewController ()
@property (nonatomic, weak) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) STUser *user;
@property (nonatomic, strong) STApiService *apiService;
@property (nonatomic, strong) STDataService *dataService;


@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSString *userFile;

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSTimer *updateTimer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateData;

@property (nonatomic) BOOL rowLoading;
@end

@implementation STProfileViewController
@synthesize dataService = _dataService;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataService = [[STDataService alloc] init];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [iView stopAnimating];
            [iView removeFromSuperview];
        });
    });
    
    _rowLoading = NO;
    [self startUpdateTimer];
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
    // Show the statusbar activity indicator
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    // Run in seperate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Update the user data
        [self setUser:[_apiService getUserFromJSON]];
        
        // Update recently played games data
        [_user updateRecentGames:[_apiService getRecentPlayedGamesFromJSON]];
        [self reloadTableAsync];
        
        // Update hours played
        [_user updateHoursPlayed];
        
        // Save the updated data
        [_dataService saveUser:_user];
        
        // Update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            _updateData.title   = @"Update";
            _updateData.enabled = YES;
            
            // Remove the statusbar activity indicator
            app.networkActivityIndicatorVisible = NO;
            
            [self setUserItems];
        });
    });
}

#pragma mark - User Functions
// Init the user from decoder or from JSON and the encode
- (void)initUser
{
    // Check if user has been saved already
    // if so load from memory
    if ([_defaults objectForKey:@"encodedUser"] != nil) {
        _user = [_dataService getUserFromUnarchiver];
        [self reloadTableAsync];
        
    } else {
        // User not in memory so load from API
        _user = [_apiService getUserFromJSON];
        
        // Save User
        // Use async to unload main thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_user updateRecentGames:[_apiService getRecentPlayedGamesFromJSON]];
            [self reloadTableAsync];
            
            [_dataService saveUser:_user];
        });
    }
    
    // Set the UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUserItems];
    });
}

- (void)setUserItems
{
    // Update the user name and set status to last seen time
    _usernameLabel.text = _user.playerName;
    _lastSeenLabel.text = [[NSString alloc] initWithFormat:@"Last seen: %@",_user.lastLogOff];
    
    // Update the User played hours labels
    _recentHoursLabel.text = [NSString stringWithFormat:@"%@ hours past 2 weeks", _user.recentHours ];
    _totalHoursLabel.text = [NSString stringWithFormat:@"%@ hours on record", _user.totalHours];
    
    // Update the user status
    [self updateUserStatus];
    
    // Load the user image
    [self loadImageAsync:_userImage WithImage:_user.avatar];
}

- (void)updateUserStatus
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *lastSeenLabel = _lastSeenLabel.text;
        
        NSInteger onlineState = [[_apiService getUserStatus] integerValue];
        switch (onlineState) {
            case 1:
                lastSeenLabel = @"Online"; break;
            case 2:
                lastSeenLabel = @"Busy"; break;
            case 3:
                lastSeenLabel = @"Away"; break;
            case 4:
                lastSeenLabel = @"Snooze"; break;
            case 5:
                lastSeenLabel = @"Looking to trade"; break;
            case 6:
                lastSeenLabel = @"Looking to play"; break;
                
            default:
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![lastSeenLabel isEqualToString:_lastSeenLabel.text]){
                _lastSeenLabel.text = lastSeenLabel;
            }
        });
    });
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
    
    // TextLabel formatting
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    // DetailLabel formatting
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    STUserGame *game    = (STUserGame *)[_user.recentGames objectAtIndex:indexPath.row];
    cell.textLabel.text = game.gameName;
    
    // The hours played over last two weeks and in total
    cell.detailTextLabel.text   = ([game.playtimeTwoWeeks floatValue] > 0) ? [NSString stringWithFormat:@"%@ hours past 2 weeks / %.1f hours on record", game.playtimeTwoWeeks, [game.playtimeForever floatValue]] : [NSString stringWithFormat:@"%.1f hours on record", [game.playtimeForever floatValue]] ;
    
    // Set the game icon
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imageView.image    = game.imgIcon;
        [cell setNeedsLayout];
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_rowLoading == NO) {
        // Set rowloading to YES
        _rowLoading = YES;
        
        // Get the game for this row
        STUserGame *game = (STUserGame *)[_user.recentGames objectAtIndex:indexPath.row];
        
        // Add activity indicator
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0, 0, 24, 24);
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = spinner;
        [spinner startAnimating];
        
        // Check if the game has it's achievements loaded and they are not older than 30min
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if([game checkAchievements]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [_dataService saveUser:_user];
                });
            }
            
            // Everything is loaded so show the game achievements view
            dispatch_sync(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                cell.accessoryView = nil;
                
                _rowLoading = NO;
                [self performSegueWithIdentifier:@"AchievementView" sender:game];
            });
        });
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_user.recentGames removeObjectAtIndex:indexPath.row];
        [self reloadTableAsync];
    }
}

#pragma mark - NavigationBar

- (IBAction)updateDataClick:(id)sender {
    _updateData.title   = @"Updating";
    _updateData.enabled = NO;
    [self updateData:_updateTimer];
}

- (IBAction)logoutUser:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Log out"];
    [alert setMessage:@"Are you sure you want to log out?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_dataService logoutUser];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    STAchievementViewController *controller = (STAchievementViewController *)[segue destinationViewController];
    STUserGame *game = (STUserGame *)sender;
    
    controller.game = game;
    controller.achievementArray = [game.achievements allValues];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_dataService saveUser:_user];
}

@end
