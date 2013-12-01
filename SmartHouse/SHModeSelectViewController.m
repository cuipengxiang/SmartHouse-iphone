//
//  SHModeSelectViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-25.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHModeSelectViewController.h"
#import "SHSettingsNewViewController.h"

#define MODE_BTN_BASE_TAG 1000

@interface SHModeSelectViewController ()

@end

@implementation SHModeSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.socketQueue = dispatch_queue_create("socketQueue1", NULL);
        currentPage = 0;
        skipQuery = 0;
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
    
    scrollBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, App_Height - 44.0)];
    [scrollBackView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_mode_iphone"]]];
    [self.view addSubview:scrollBackView];
    
    scrollLeft = [[UIButton alloc] initWithFrame:CGRectMake(24.5, (App_Height - 44.0 - 39.0)/2, 21.0, 39.0)];
    [scrollLeft setBackgroundImage:[UIImage imageNamed:@"left_iphone"] forState:UIControlStateNormal];
    [scrollLeft setBackgroundImage:[UIImage imageNamed:@"left_iphone"] forState:UIControlStateSelected];
    [scrollLeft addTarget:self action:@selector(onScrollLeftClick) forControlEvents:UIControlEventTouchUpInside];
    
    scrollRight = [[UIButton alloc] initWithFrame:CGRectMake(274.5, (App_Height - 44.0 - 39.0)/2, 21.0, 39.0)];
    [scrollRight setBackgroundImage:[UIImage imageNamed:@"right_iphone"] forState:UIControlStateNormal];
    [scrollRight setBackgroundImage:[UIImage imageNamed:@"right_iphone"] forState:UIControlStateSelected];
    [scrollRight addTarget:self action:@selector(onScrollRightClick) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollBackView addSubview:scrollLeft];
    [scrollBackView addSubview:scrollRight];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60.0, (App_Height - 44.0 - 300.0)/2, 200.0, 300.0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setBounces:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setPagingEnabled:YES];
    pageCount = 0;
    if (self.model.modesNames.count%3 == 0) {
        pageCount = self.model.modesNames.count/3;
    } else {
        pageCount = self.model.modesNames.count/3 + 1;
    }
    [scrollView setContentSize:CGSizeMake(180.0*pageCount, 300.0f)];
    [scrollBackView addSubview:scrollView];
    
    for (int i = 0; i < self.model.modesNames.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(18.0+i/3*200.0 , 25.0 + i%3*96.0, 164.0, 58.0)];
        [button setTag:i + MODE_BTN_BASE_TAG];
        [button setBackgroundImage:[UIImage imageNamed:@"mode_normal_iphone"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"mode_selected_iphone"] forState:UIControlStateSelected];
        [button setTitle:[self.model.modesNames objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitle:[self.model.modesNames objectAtIndex:i] forState:UIControlStateSelected];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onModeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
}

- (void)onScrollLeftClick
{
    currentPage = scrollView.contentOffset.x/200.0;
    if (currentPage > 0) {
        CGPoint point = CGPointMake((currentPage - 1) * 200.0, scrollView.contentOffset.y);
        [scrollView setContentOffset:point animated:YES];
    }
}

- (void)onScrollRightClick
{
    if ((int)scrollView.contentOffset.x % 200 != 0) {
        currentPage = scrollView.contentOffset.x/200.0 + 1;
    } else {
        currentPage = scrollView.contentOffset.x/200.0;
    }
    if (currentPage < pageCount - 1) {
        CGPoint point = CGPointMake((currentPage + 1) * 200.0, scrollView.contentOffset.y);
        [scrollView setContentOffset:point animated:YES];
    }
}


- (void)onModeButtonClick:(UIButton *)button
{
    
    for (int i = MODE_BTN_BASE_TAG; i < MODE_BTN_BASE_TAG + self.model.modesNames.count; i++) {
        [(UIButton *)[scrollView viewWithTag:i] setSelected:NO];
    }
    [button setSelected:YES];
    
    skipQuery = 1;
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
    if (skipQuery == 1) {
        skipQuery = 0;
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
                    [(UIButton *)[scrollView viewWithTag:i] setSelected:YES];
                } else {
                    [(UIButton *)[scrollView viewWithTag:i] setSelected:NO];
                }
            }
        }
    });
}


- (void)onBackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)onSettingsButtonClick
{
    SHSettingsNewViewController *controller = [[SHSettingsNewViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:controller animated:YES completion:^(void){
    }];
}


//点击场景模式按钮
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
