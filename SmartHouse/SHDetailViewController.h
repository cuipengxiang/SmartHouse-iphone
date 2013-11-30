//
//  SHDetailViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-28.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHStateViewController.h"
#import "AppDelegate.h"
#import "SHRoomModel.h"
#import "GCDAsyncSocket.h"

@interface SHDetailViewController : SHStateViewController<GCDAsyncSocketDelegate>
{
    UIScrollView *detailView;
    int detailType;
}

@property (nonatomic)dispatch_queue_t socketQueue;
@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property (nonatomic, strong)SHRoomModel *model;
@property(nonatomic, strong)UINavigationBar *navigationBar;
@property(nonatomic, strong)UIButton *networkStateButton;
@property(nonatomic, strong)UIBarButtonItem *networkBarButton;
@property(nonatomic, strong)UINavigationItem *item;

- (id)initWithType:(int)type;
- (void)setupNavigationBar:(float)width;
- (void)onBackButtonClick;
- (void)onSettingButtonClick;

@end
