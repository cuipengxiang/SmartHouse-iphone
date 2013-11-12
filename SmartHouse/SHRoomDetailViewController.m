//
//  SHRoomDetailViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-7.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHRoomDetailViewController.h"

#define MODE_BTN_BASE_TAG 1000

@interface SHRoomDetailViewController ()

@end

@implementation SHRoomDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueue1", NULL);
        self.myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    [left addTarget:self action:@selector(onScrollLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    right = [[UIButton alloc] initWithFrame:CGRectMake(280.0, 58.5, 21.0, 39.0)];
    [right setImage:[UIImage imageNamed:@"right_iphone"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(onScrollRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [modeView addSubview:left];
    [modeView addSubview:right];
    
    modeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(60.0, 48.0, 200.0, 60.0)];
    [modeScroll setBackgroundColor:[UIColor clearColor]];
    [modeView addSubview:modeScroll];
    [self setupModeSelectBar:self.model];
    
    [self.myAppDelegate startQuery:self.model from:self];
}

- (void)onBackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)setupModeSelectBar:(SHRoomModel *)currentModel
{
    self.currentModePage = 0;
    [modeScroll setBounces:YES];
    [modeScroll setShowsHorizontalScrollIndicator:NO];
    [modeScroll setContentOffset:CGPointMake(0, 0)];
    [modeScroll setPagingEnabled:YES];
    
    [modeScroll setContentSize:CGSizeMake(200.0*self.model.modesNames.count, 60.0f)];
    for (int i = 0; i < self.model.modesNames.count; i++) {
        UIButton *modeButton = [[UIButton alloc] initWithFrame:CGRectMake(18.0 + i*200.0, 1.0, 164.0, 58.0)];
        [modeButton setTitle:[self.model.modesNames objectAtIndex:i] forState:UIControlStateNormal];
        [modeButton setTitle:[self.model.modesNames objectAtIndex:i] forState:UIControlStateSelected];
        [modeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [modeButton setBackgroundImage:[UIImage imageNamed:@"mode_normal_iphone"] forState:UIControlStateNormal];
        [modeButton setBackgroundImage:[UIImage imageNamed:@"mode_selected_iphone"] forState:UIControlStateSelected];
        [modeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [modeButton setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
        [modeButton setTag:MODE_BTN_BASE_TAG + i];
        [modeButton addTarget:self action:@selector(onModeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [modeScroll addSubview:modeButton];
    }
}

- (void)onScrollLeftClick:(id)sender
{
    self.currentModePage = modeScroll.contentOffset.x/200.0;
    if (self.currentModePage > 0) {
        self.currentModePage = self.currentModePage - 1;
        CGPoint point = CGPointMake(200.0*self.currentModePage, 0.0);
        [modeScroll setContentOffset:point animated:YES];
    }
}

- (void)onScrollRightClick:(id)sender
{
    if ((int)modeScroll.contentOffset.x % 200 != 0) {
        self.currentModePage = modeScroll.contentOffset.x/200.0 + 1;
    } else {
        self.currentModePage = modeScroll.contentOffset.x/200.0;
    }
    if (self.currentModePage < self.model.modesNames.count - 1) {
        self.currentModePage = self.currentModePage + 1;
        CGPoint point = CGPointMake(200.0*self.currentModePage, 0.0);
        [modeScroll setContentOffset:point animated:YES];
    }
}

- (void)onModeButtonClick:(UIButton *)button
{
    for (int i = MODE_BTN_BASE_TAG; i < MODE_BTN_BASE_TAG + self.model.modesNames.count; i++) {
        [(UIButton *)[modeScroll viewWithTag:i] setSelected:NO];
    }
    [button setSelected:YES];
    
    self.skipQuery = 1;
    NSString *commandSend = [NSString stringWithFormat:@"%@\r\n", [self.model.modesCmds objectAtIndex:button.tag - MODE_BTN_BASE_TAG]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        socket.command = commandSend;
        [socket connectToHost:self.myAppDelegate.host onPort:self.myAppDelegate.port withTimeout:3.0 error:&error];
    });
}


- (void)setCurrentMode:(NSString *)mode
{
    //跳过点击按钮后的第一次查询
    if (self.skipQuery == 1) {
        self.skipQuery = 0;
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        int btn_tag = -1;
        for (int i = MODE_BTN_BASE_TAG; i < MODE_BTN_BASE_TAG + self.model.modesNames.count; i++) {
            int location = [mode rangeOfString:[self.model.modeBacks objectAtIndex:i - MODE_BTN_BASE_TAG]].location;
            
            if (location == INT32_MAX) {
                //[(UIButton *)[self.modeView viewWithTag:i] setSelected:NO];
            } else {
                //[(UIButton *)[self.modeView viewWithTag:i] setSelected:YES];
                btn_tag = i;
            }
        }
        if (btn_tag > 0) {
            for (int i = MODE_BTN_BASE_TAG; i < MODE_BTN_BASE_TAG + self.model.modesNames.count;i++) {
                if (i == btn_tag) {
                    [(UIButton *)[modeScroll viewWithTag:i] setSelected:YES];
                } else {
                    [(UIButton *)[modeScroll viewWithTag:i] setSelected:NO];
                }
            }
        }
    });
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
    [sock disconnect];
    sock = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
