//
//  SHRoomsListViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-5.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLoginViewController.h"
#import "AppDelegate.h"

@interface SHRoomsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)AppDelegate *myAppDelegate;
@property(nonatomic, retain)SHLoginViewController *backController;
@property(nonatomic, strong)UINavigationBar *navigationBar;
@property(nonatomic, strong)UIButton *networkStateButton;
@property(nonatomic, strong)UIBarButtonItem *networkBarButton;
@property(nonatomic, strong)UINavigationItem *item;
@property(nonatomic, strong)UITableView *tableView;

- (void)setupNavigationBar:(float)width;

@end
