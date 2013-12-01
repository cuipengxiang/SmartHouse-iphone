//
//  SHDetailViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-28.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHDetailViewController.h"
#import "SHDetailContolView.h"
#import "SHMusicControlView.h"
#import "SHSettingsNewViewController.h"

@interface SHDetailViewController ()

@end

@implementation SHDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueue2", NULL);
        self.myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (id)initWithType:(int)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        detailType = type;
        self.socketQueue = dispatch_queue_create("socketQueue2", NULL);
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_detail_iphone"]]];
    
    detailView = [[UIScrollView alloc] initWithFrame:CGRectMake(5.0, 54.0, 310.0, App_Height - 64.0)];
    [detailView setBackgroundColor:[UIColor clearColor]];
    [detailView setShowsHorizontalScrollIndicator:NO];
    [detailView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:detailView];
    
    switch (detailType) {
        case LIGHT_TAG:
            [detailView setContentSize:CGSizeMake(310.0, self.model.lightNames.count*146.0 - 15.0)];
            for (int i = 0; i < self.model.lightNames.count; i++) {
                SHDetailContolView *detailViewPanel = [[SHDetailContolView alloc] initWithFrame:CGRectMake(27.0, i*146.0, 256.0, 126.0)andTitle:[self.model.lightNames objectAtIndex:i] andType:LIGHT_TAG andController:self];
                [detailViewPanel setButtons:[self.model.lightBtns objectAtIndex:i] andCmd:[self.model.lightCmds objectAtIndex:i]];
                [detailView addSubview:detailViewPanel];
            }
            break;
        case CURTAIN_TAG:
            [detailView setContentSize:CGSizeMake(310.0, self.model.curtainNames.count*146.0 - 15.0)];
            for (int i = 0; i < self.model.curtainNames.count; i++) {
                SHDetailContolView *detailViewPanel = [[SHDetailContolView alloc] initWithFrame:CGRectMake(27.0, i*146.0, 256.0, 126.0)andTitle:[self.model.curtainNames objectAtIndex:i] andType:CURTAIN_TAG andController:self];
                [detailViewPanel setButtons:[self.model.curtainBtns objectAtIndex:i] andCmd:[self.model.curtainCmds objectAtIndex:i]];
                [detailView addSubview:detailViewPanel];
            }
            break;
            
        case MUSIC_TAG:
            [detailView setContentSize:CGSizeMake(310.0, self.model.musicCmds.count*275.0 - 5.0)];
            for (int i = 0; i < self.model.musicNames.count; i++) {
                SHMusicControlView *detailViewPanel = [[SHMusicControlView alloc] initWithFrame:CGRectMake(3.5, i*275.0, 303.0, 265.0) andTitle:[self.model.musicNames objectAtIndex:i] andController:self];
                [detailViewPanel setButtons:[self.model.musicBtns objectAtIndex:i] andCmd:[self.model.musicCmds objectAtIndex:i]];
                [detailView addSubview:detailViewPanel];
            }
            break;
    }
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
