//
//  SHSettingsNewViewController.h
//  SmartHouse
//
//  Created by Roc on 13-10-25.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SHSettingsViewController.h"

@interface SHSettingsNewViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIView *settingbox;
@property(nonatomic, strong)UIButton *password;
@property(nonatomic, strong)UIButton *network;
@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property(nonatomic, strong)UIButton *backButton;

- (void)onBackButtonClick:(id)sender;
- (void)onPasswordClick:(id)sender;
- (void)onNetworkClick:(id)sender;

@end
