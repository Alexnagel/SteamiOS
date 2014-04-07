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
@property (strong, nonatomic) NSString *loginURL;
@property (nonatomic) BOOL viewPushed;
@property (strong, nonatomic) IBOutlet UIButton *refreshPage;
@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loginURL = @"https://steamcommunity.com/mobilelogin";
	
    [self setViewPushed:NO];
    if ([self userIsLoggedIn] == NO) {
        [self loadWebView];
    }
}

- (void)loadWebView
{
    [self.loginWebView addSubview:_loadingIndicator];
    self.loginWebView.delegate = self;
    self.title = @"Login";
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
    [_loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_loadingIndicator startAnimating];
    
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loginURL]]];
}

- (IBAction)refreshPage:(id)sender
{
    [self.loginWebView reload];
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
    [_loadingIndicator removeFromSuperview];
    
    [theWebView stringByEvaluatingJavaScriptFromString:@"var myNode = document.getElementById(\"global_header\");while (myNode.firstChild) {myNode.removeChild(myNode.firstChild);}"];
    
    NSString* token = [self getUserIDFromCookie];
    if (token != nil) {
        //[self saveUserID:token];
        [self saveUserID:@"76561198063049991"]; //turbodevin
        //[self saveUserID:@"76561198041686803"]; //turbojarno
        [self userIsLoggedIn];
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
    
    if (userID != Nil && !_viewPushed) {
        [self performSegueWithIdentifier:@"ProfileView" sender:self];
        [self setViewPushed:YES];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
