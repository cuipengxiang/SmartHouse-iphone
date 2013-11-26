//
//  SHModeSelectViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-25.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHStateViewController.h"
#import "AppDelegate.h"
#import "SHRoomModel.h"

@interface SHModeSelectViewController : SHStateViewController
{
    UIScrollView *scrollView;
    UIButton *scrollLeft;
    UIButton *scrollRight;
}

@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property (nonatomic, strong)SHRoomModel *model;
@property(nonatomic, strong)UINavigationBar *navigationBar;
@property(nonatomic, strong)UIButton *networkStateButton;
@property(nonatomic, strong)UIBarButtonItem *networkBarButton;
@property(nonatomic, strong)UINavigationItem *item;

- (void)setupNavigationBar:(float)width;
- (void)onBackButtonClick;
- (void)onSettingButtonClick;

@end
