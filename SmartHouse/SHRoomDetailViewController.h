//
//  SHRoomDetailViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-7.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHRoomModel.h"
#import "AppDelegate.h"
#import "SHStateViewController.h"

@interface SHRoomDetailViewController : SHStateViewController
{
    UIButton *light;
    UIButton *curtain;
    UIButton *music;
    UIButton *mode;
    UIButton *network;
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
- (void)onMusicButtonClick;
- (void)onLightButtonClick;
- (void)onCurtainButtonClick;
- (void)onModeButtonClick;
- (void)onNetWorkButtonClick;


@end
