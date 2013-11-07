//
//  SHRoomDetailViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-7.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHRoomDetailViewController.h"

@interface SHRoomDetailViewController ()

@end

@implementation SHRoomDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setupNavigationBar:(float)width
{
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg_iphone"] forBarMetrics:UIBarMetricsDefault];
    
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
    [self.networkStateButton setBackgroundImage:[UIImage imageNamed:@"network_connected_iphone"] forState:UIControlStateNormal];
    [self.networkStateButton sizeToFit];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.networkBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.networkStateButton];
    
    NSArray *rightButtons = @[rightBarButton, self.networkBarButton];
    
    self.item = [[UINavigationItem alloc] init];
    [self.item setLeftBarButtonItem:leftBarButton];
    [self.item setRightBarButtonItems:rightButtons];
    
    [self.navigationBar pushNavigationItem:self.item animated:NO];
    [self.view addSubview:self.navigationBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0]];
    [self setupNavigationBar:320.0];
	modeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 69.0, 320.0, 156.0)];
    [modeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mode_bg_iphone"]]];
    [self.view addSubview:modeView];
    
    light = [[UIButton alloc] initWithFrame:CGRectMake(22.0, 263.0, 76.0, 81.0)];
    curtain = [[UIButton alloc] initWithFrame:CGRectMake(122.0, 263.0, 76.0, 81.0)];
    music = [[UIButton alloc] initWithFrame:CGRectMake(222.0, 263.0, 76.0, 81.0)];
    [light setImage:[UIImage imageNamed:@"btn_light_iphone"] forState:UIControlStateNormal];
    [curtain setImage:[UIImage imageNamed:@"btn_curtain_iphone"] forState:UIControlStateNormal];
    [music setImage:[UIImage imageNamed:@"btn_music_iphone"] forState:UIControlStateNormal];
    [self.view addSubview:light];
    [self.view addSubview:curtain];
    [self.view addSubview:music];
    
    left = [[UIButton alloc] initWithFrame:CGRectMake(19.0, 58.5, 21.0, 39.0)];
    [left setImage:[UIImage imageNamed:@"left_iphone"] forState:UIControlStateNormal];
    right = [[UIButton alloc] initWithFrame:CGRectMake(280.0, 58.5, 21.0, 39.0)];
    [right setImage:[UIImage imageNamed:@"right_iphone"] forState:UIControlStateNormal];
    [modeView addSubview:left];
    [modeView addSubview:right];
}

- (void)onBackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
