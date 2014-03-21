//
//  STViewController.h
//  Steam
//
//  Created by Alex Nagelkerke on 14-03-14.
//  Copyright (c) 2014 Alex Nagelkerke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STViewController : UIViewController <UIWebViewDelegate>{
    IBOutlet UIView *mainView;
}

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

@end
