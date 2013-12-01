//
//  AppDelegate.h
//  SmartHouse
//
//  Created by Roc on 13-8-13.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLoginViewController.h"
#import "GCDAsyncSocket.h"
#import "SHReadConfigFile.h"
#import "SHRoomModel.h"
#import "SHStateViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GCDAsyncSocketDelegate>

@property(nonatomic) dispatch_queue_t socketQueue;
@property BOOL candown;
@property BOOL canup;
@property(strong) SHStateViewController *mainController;
@property(strong, nonatomic) NSString *host;
@property(strong, nonatomic) NSString *host1;
@property(strong, nonatomic) NSString *host2;
@property(nonatomic)int16_t port;
@property(strong, nonatomic) NSMutableArray *models;
@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) SHLoginViewController *viewController;
@property(strong, nonatomic) SHRoomModel *model;
@property(nonatomic, strong) NSThread *myModeThread;
@property BOOL networkState;

- (void)sendCommand:(NSString *)command;
- (void)startQuery:(SHRoomModel *)queryModel from:(UIViewController *)controller;
- (void)stopQuery;

@end
