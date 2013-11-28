//
//  SHDetailViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-28.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHDetailViewController.h"

@interface SHDetailViewController ()

@end

@implementation SHDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithType:(int)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        detailType = type;
    }
    return self;
}

- (void)setupNavigationBar:(float)width
{
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_iphone"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:self.model.name];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_return_iphone"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [leftButton addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_setup_iphone"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [rightButton addTarget:self action:@selector(onSettingsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    
    self.networkStateButton = [[UIButton alloc] init];
    NSString *networkImage;
    if (self.myAppDelegate.networkState) {
        networkImage = @"network_connected_iphone";
    } else {
        networkImage = @"network_disconnected_iphone";
    }
    [self.networkStateButton setBackgroundImage:[UIImage imageNamed:networkImage] forState:UIControlStateNormal];
    [self.networkStateButton sizeToFit];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.networkBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.networkStateButton];
    
    NSArray *rightButtons = @[rightBarButton, self.networkBarButton];
    
    self.item = [[UINavigationItem alloc] init];
    [self.item setLeftBarButtonItem:leftBarButton];
    [self.item setRightBarButtonItems:rightButtons];
    [self.item setTitleView:titleLabel];
    
    [self.navigationBar pushNavigationItem:self.item animated:NO];
    [self.view addSubview:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.myAppDelegate startQuery:self.model from:self];
    NSString *networkImage;
    if (self.myAppDelegate.networkState) {
        networkImage = @"network_connected_iphone";
    } else {
        networkImage = @"network_disconnected_iphone";
    }
    [self.networkStateButton setBackgroundImage:[UIImage imageNamed:networkImage] forState:UIControlStateNormal];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupNavigationBar:320.0];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)onBackButtonClick
{
    
}

- (void)onSettingButtonClick
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
