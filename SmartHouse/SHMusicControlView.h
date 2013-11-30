//
//  SHMusicControlView.h
//  SmartHouse
//
//  Created by Roc on 13-8-16.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SHDetailViewController.h"
#import "GCDAsyncSocket.h"

@interface SHMusicControlView : UIView

@property (nonatomic ,strong)AppDelegate *myDelegate;
@property (nonatomic, strong)NSMutableArray *buttonNames;
@property (nonatomic, strong)NSMutableArray *buttonCmds;
@property (nonatomic, retain)SHDetailViewController *controller;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)titleString andController:(SHDetailViewController *)controller;
- (void)setButtons:(NSMutableArray *)names andCmd:(NSMutableArray *)cmds;
- (void)onButtonClick:(UIButton *)button;

@end