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

- (void)initUser
{
    if ([_defaults objectForKey:@"encodedUser"] != nil) {
        _user = (STUser *)[NSKeyedUnarchiver unarchiveObjectWithFile:_userFile];
    } else {
        _user = [_apiService getUserJSON];
        
        // Save User
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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

- (UIActivityIndicatorView *)createIndicatorViewWithText:(NSString *)text
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(145, 190, 50,30);
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    activityIndicator.backgroundColor = [UIColor clearColor];
    
    CGFloat labelX = activityIndicator.bounds.size.width + 2;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0.0f, 50 - (labelX + 2), 20)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.numberOfLines = 1;
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    
    [activityIndicator addSubview:label];
    
    return activityIndicator;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)logoutUser:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userID"];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
