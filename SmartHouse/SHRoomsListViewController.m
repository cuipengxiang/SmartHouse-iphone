//
//  SHRoomsListViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-5.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHRoomsListViewController.h"
#import "SHRoomCell.h"
#import "SHRoomDetailViewController.h"

@interface SHRoomsListViewController ()

@end

@implementation SHRoomsListViewController

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
    [titleLabel setText:@"房间"];
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg_iphone"]]];
    [self setupNavigationBar:320.0];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 54.0, 300.0, App_Height - 44 - 20)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg_iphone"]]];
    [self.tableView setBounces:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.myAppDelegate startQuery:nil from:self];
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

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHRoomDetailViewController *controller = [[SHRoomDetailViewController alloc] initWithNibName:nil bundle:nil];
    controller.model = [(SHRoomCell *)[tableView cellForRowAtIndexPath:indexPath] data];
    [self presentViewController:controller animated:YES completion:^(void){
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.;
}


#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"RoomsTableCell";
    SHRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SHRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *roomName = [[self.myAppDelegate.models objectAtIndex:indexPath.row] name];
    [cell.textLabel setText:roomName];
    cell.data = [self.myAppDelegate.models objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row == 0) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myAppDelegate.models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
