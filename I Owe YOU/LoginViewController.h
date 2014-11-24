//
//  LoginViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 07.07.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <BButton/BButton.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet BButton *logInButton;

- (IBAction)logInButtonClickHandler:(id)sender;

@end
