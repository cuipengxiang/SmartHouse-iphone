//
//  SHRoomsListViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-5.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SHStateViewController.h"

@interface SHRoomsListViewController : SHStateViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property(nonatomic, retain)SHLoginViewController *backController;
@property(nonatomic, strong)UINavigationBar *navigationBar;
@property(nonatomic, strong)UIBarButtonItem *networkBarButton;
@property(nonatomic, strong)UINavigationItem *item;
@property(nonatomic, strong)UITableView *tableView;

- (void)setupNavigationBar:(float)width;
- (void)onBackButtonClick;
- (void)onSettingsButtonClick;

@end
