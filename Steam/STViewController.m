//
//  STViewController.m
//  Steam
//
//  Created by Alex Nagelkerke on 14-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import "STViewController.h"

@interface STViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;
@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([self userIsLoggedIn] == NO) {
        [self loadWebView];
    } else {
        [self performSegueWithIdentifier:@"ProfileView" sender:self];
    }
}

- (void)loadWebView
{
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
    [_loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_loadingIndicator setHidesWhenStopped:YES];
    
    [self.loginWebView addSubview:_loadingIndicator];
    self.loginWebView.delegate = self;
    
    NSString *urlString = @"https://steamcommunity.com/login/home";
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (NSString*)getUserIDFromCookie {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([[cookie domain] isEqualToString:@"steamcommunity.com"]) {
            if ([[cookie name] isEqualToString:@"steamLogin"]) {
                NSArray *cookieArr = [cookie.value componentsSeparatedByString:@"%7C"];
                NSString *steamID  = [cookieArr objectAtIndex:0];
                
                return steamID;
            }
        }
    }
    return nil;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [_loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [_loadingIndicator stopAnimating];
    
    NSString* token = [self getUserIDFromCookie];
    if (token != nil) {
        [self saveUserID:token];
        [theWebView removeFromSuperview];
    }
}

- (void)saveUserID:(NSString *)userID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userID forKey:@"userID"];
    
    [defaults synchronize];
}

- (BOOL)userIsLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults stringForKey:@"userID"];
    
    if (userID != Nil) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
