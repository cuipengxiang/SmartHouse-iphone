//
//  SHStateViewController.m
//  SmartHouse
//
//  Created by Roc on 13-11-11.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHStateViewController.h"

@interface SHStateViewController ()

@end

@implementation SHStateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setNetworkState:(BOOL)isConnected
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (isConnected) {
            [self.networkStateButton setBackgroundImage:[UIImage imageNamed:@"network_connected_iphone"] forState:UIControlStateNormal];
        } else {
            [self.networkStateButton setBackgroundImage:[UIImage imageNamed:@"network_disconnected_iphone"] forState:UIControlStateNormal];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
