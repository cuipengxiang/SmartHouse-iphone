//
//  SHStateViewController.h
//  SmartHouse
//
//  Created by Roc on 13-11-11.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHStateViewController : UIViewController

@property(nonatomic, strong)UIButton *networkStateButton;

- (void)setNetworkState:(BOOL)isConnected;

@end
