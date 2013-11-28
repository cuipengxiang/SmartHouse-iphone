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
#import "GCDAsyncSocket.h"

@interface SHModeSelectViewController : SHStateViewController<GCDAsyncSocketDelegate>
{
    UIView *scrollBackView;
    UIScrollView *scrollView;
    UIButton *scrollLeft;
    UIButton *scrollRight;
    int currentPage;
    int pageCount;
    int skipQuery;
}
@property(nonatomic)dispatch_queue_t socketQueue;
@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property (nonatomic, strong)SHRoomModel *model;
@property(nonatomic, strong)UINavigationBar *navigationBar;
@property(nonatomic, strong)UIButton *networkStateButton;
@property(nonatomic, strong)UIBarButtonItem *networkBarButton;
@property(nonatomic, strong)UINavigationItem *item;

- (void)setupNavigationBar:(float)width;
- (void)onBackButtonClick;
- (void)onSettingButtonClick;
- (void)onScrollLeftClick;
- (void)onScrollRightClick;
- (void)setCurrentMode:(NSString *)mode;
- (void)onModeButtonClick:(UIButton *)button;

@end
