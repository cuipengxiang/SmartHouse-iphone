//
//  SHRoomDetailViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-7.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHRoomDetailViewController.h"
#import "SHModeSelectViewController.h"
#import "SHDetailViewController.h"

@interface SHRoomDetailViewController ()

@end

@implementation SHRoomDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0]];
    [self setupNavigationBar:320.0];
    
    mode = [[UIButton alloc] initWithFrame:CGRectMake(65.0, 184.0, 76.0, 81.0)];
    light = [[UIButton alloc] initWithFrame:CGRectMake(179.0, 184.0, 76.0, 81.0)];
    curtain = [[UIButton alloc] initWithFrame:CGRectMake(65.0, 303.0, 76.0, 81.0)];
    music = [[UIButton alloc] initWithFrame:CGRectMake(179.0, 303.0, 76.0, 81.0)];
    [light setImage:[UIImage imageNamed:@"btn_light_iphone"] forState:UIControlStateNormal];
    [curtain setImage:[UIImage imageNamed:@"btn_curtain_iphone"] forState:UIControlStateNormal];
    [music setImage:[UIImage imageNamed:@"btn_music_iphone"] forState:UIControlStateNormal];
    [mode setImage:[UIImage imageNamed:@"btn_mode_iphone"] forState:UIControlStateNormal];
    [light setTag:LIGHT_TAG];
    [curtain setTag:CURTAIN_TAG];
    [music setTag:MUSIC_TAG];
    [light addTarget:self action:@selector(onDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [curtain addTarget:self action:@selector(onDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [music addTarget:self action:@selector(onDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mode addTarget:self action:@selector(onModeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:light];
    [self.view addSubview:curtain];
    [self.view addSubview:music];
    [self.view addSubview:mode];
    
    network = [[UIButton alloc] initWithFrame:CGRectMake(88.0, 74.0, 144.0, 36.0)];
    NSString *imageName;
    if ([self.myAppDelegate.host isEqualToString:self.myAppDelegate.host1]) {
        imageName = @"btn_network_in_iphone";
    } else {
        imageName = @"btn_network_out_iphone";
    }
    [network setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [network addTarget:self action:@selector(onNetWorkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:network];
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

- (void)onBackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)onSettingButtonClick
{
    
}

- (void)onNetWorkButtonClick
{
    NSString *imageName;
    if ([self.myAppDelegate.host isEqualToString:self.myAppDelegate.host1]) {
        imageName = @"btn_network_out_iphone";
        self.myAppDelegate.host = self.myAppDelegate.host2;
    } else {
        imageName = @"btn_network_in_iphone";
        self.myAppDelegate.host = self.myAppDelegate.host1;
    }
    [network setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:self.myAppDelegate.host forKey:@"host"];
}

- (void)onModeButtonClick
{
    SHModeSelectViewController *controller = [[SHModeSelectViewController alloc] initWithNibName:nil bundle:nil];
    controller.model = self.model;
    [self presentViewController:controller animated:YES completion:^(void){
    }];
}

- (void)onDetailButtonClick:(UIButton *)button
{
    SHDetailViewController *detailer = [[SHDetailViewController alloc] initWithType:button.tag];
    detailer.model = self.model;
    [self presentViewController:detailer animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
