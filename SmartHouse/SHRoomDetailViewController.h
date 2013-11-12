//
//  SHRoomDetailViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-7.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHRoomModel.h"
#import "GCDAsyncSocket.h"
#import "AppDelegate.h"
#import "SHStateViewController.h"

@interface SHRoomDetailViewController : SHStateViewController<GCDAsyncSocketDelegate>
{
    UIButton *left;
    UIButton *right;
    UIButton *light;
    UIButton *curtain;
    UIButton *music;
    UIView *modeView;
    UIScrollView *modeScroll;
}

@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property(nonatomic)dispatch_queue_t socketQueue;
@property (nonatomic, strong)SHRoomModel *model;
@property(nonatomic, strong)UINavigationBar *navigationBar;
@property(nonatomic, strong)UIButton *networkStateButton;
@property(nonatomic, strong)UIBarButtonItem *networkBarButton;
@property(nonatomic, strong)UINavigationItem *item;
@property(nonatomic)int currentModePage;
@property(nonatomic)int skipQuery;

- (void)setupNavigationBar:(float)width;
- (void)onBackButtonClick;
- (void)setupModeSelectBar:(SHRoomModel *)currentModel;
- (void)onScrollLeftClick:(id)sender;
- (void)onScrollRightClick:(id)sender;
- (void)setCurrentMode:(NSString *)mode;

@end
