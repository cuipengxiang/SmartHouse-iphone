//
//  SHDetailContolView.m
//  SmartHouse
//
//  Created by Roc on 13-8-15.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHDetailContolView.h"

#define BUTTON_BASE_TAG 4000
#define BUTTON_DELAY 1.0

@implementation SHDetailContolView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)titleString andType:(int)type andController:(SHDetailViewController *)controller
{
    self = [self initWithFrame:frame andType:type];
    if (self) {
        self.myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.controller = controller;
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:titleString];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel sizeToFit];
        [titleLabel setFrame:CGRectMake((frame.size.width - titleLabel.frame.size.width)/2, 21.0, titleLabel.frame.size.width, titleLabel.frame.size.height)];
        [self addSubview:titleLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andType:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.type = type;
        if (type == LIGHT_TAG) {
            [background setImage:[UIImage imageNamed:@"light_ctrl_panel"]];
        } else if (type == CURTAIN_TAG) {
            [background setImage:[UIImage imageNamed:@"curtain_ctrl_panel"]];
        }
        [self addSubview:background];
        self.socketQueue = dispatch_queue_create("socketQueue3", NULL);
    }
    return self;
}

- (void)setButtons:(NSMutableArray *)names andCmd:(NSMutableArray *)cmds
{
    self.buttonNames = [[NSMutableArray alloc] initWithArray:names];
    self.buttonCmds = [[NSMutableArray alloc] initWithArray:cmds];
    if (names.count == 4) {
        for (int i = 0; i < names.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setFrame:CGRectMake(15.5 + i*58.0, 70.0, 51, 26)];
            [button setTag:BUTTON_BASE_TAG + i];
            if (i < 2) {
                [button setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [button setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else if (i == 2) {
                if (self.type == LIGHT_TAG) {
                    [button setBackgroundImage:[UIImage imageNamed:@"btn_light_1"] forState:UIControlStateNormal];
                } else {
                    [button setBackgroundImage:[UIImage imageNamed:@"btn_curtain_1"] forState:UIControlStateNormal];
                }
                [button addTarget:self action:@selector(onButtonDown:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(onButtonUp:) forControlEvents:UIControlEventTouchUpInside];
                [button addTarget:self action:@selector(onButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
            } else if (i == 3) {
                if (self.type == LIGHT_TAG) {
                    [button setBackgroundImage:[UIImage imageNamed:@"btn_light_2"] forState:UIControlStateNormal];
                } else {
                    [button setBackgroundImage:[UIImage imageNamed:@"btn_curtain_2"] forState:UIControlStateNormal];
                }
                [button addTarget:self action:@selector(onButtonDown:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(onButtonUp:) forControlEvents:UIControlEventTouchUpInside];
                [button addTarget:self action:@selector(onButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
            }
            [self addSubview:button];
        }
    } else if (names.count == 2) {
        for (int i = 0; i < names.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setFrame:CGRectMake(55.0 + i*95.0, 70.0, 51, 26)];
            [button setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
            [button setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
            [button setTag:BUTTON_BASE_TAG + i];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    } else if (names.count == 3) {
        for (int i = 0; i < names.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setFrame:CGRectMake(20 + i*82.5, 70.0, 51, 26)];
            [button setTag:BUTTON_BASE_TAG + i];
            
            [button setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
            [button setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
}

- (void)onButtonClick:(UIButton *)button
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.controller delegateQueue:self.controller.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", [self.buttonCmds objectAtIndex:button.tag - BUTTON_BASE_TAG]];
        [socket connectToHost:self.myDelegate.host onPort:self.myDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)onButtonUp:(UIButton *)button
{
    up = [NSDate date];
    NSTimeInterval time = [up timeIntervalSinceDate:down];
    if ((self.myDelegate.canup)&&(!self.myDelegate.candown)) {
        self.myDelegate.canup = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            if (time < 0.4) {
                [NSThread sleepForTimeInterval:0.4 - time];
            }
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [NSString stringWithFormat:@"%@\r\n", [self.buttonCmds objectAtIndex:(button.tag - BUTTON_BASE_TAG)*2 - 1]];
            [socket connectToHost:self.myDelegate.host onPort:self.myDelegate.port withTimeout:3.0 error:&error];
        });
    }
}

- (void)onButtonDown:(UIButton *)button
{
    down = [NSDate date];
    if (self.myDelegate.candown) {
        self.myDelegate.candown = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.controller delegateQueue:self.controller.socketQueue];
            socket.command = [NSString stringWithFormat:@"%@\r\n", [self.buttonCmds objectAtIndex:(button.tag - BUTTON_BASE_TAG)*2 - 2]];
            [socket connectToHost:self.myDelegate.host onPort:self.myDelegate.port withTimeout:3.0 error:&error];
        });
    }
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
    self.myDelegate.candown = YES;
    self.myDelegate.canup = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
