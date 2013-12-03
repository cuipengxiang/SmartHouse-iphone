//
//  AppDelegate.m
//  SmartHouse
//
//  Created by Roc on 13-8-13.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "AppDelegate.h"
#import "SHModeSelectViewController.h"

@implementation AppDelegate

@synthesize models;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SHLoginViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    SHReadConfigFile *fileReader = [[SHReadConfigFile alloc] init];
    [fileReader readFile];
    
    //初始化Socket连接
    self.socketQueue = dispatch_queue_create("socketQueue", NULL);
    self.myModeThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    
    if (![self.myModeThread isExecuting]) {
        [self.myModeThread start];
    }
    
    self.candown = YES;
    self.canup = YES;
    
    self.networkState = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)startQuery:(SHRoomModel *)queryModel from:(SHStateViewController *)controller
{
    self.mainController = controller;
    if (queryModel) {
        self.model = queryModel;
    } else {
        self.model = [self.models objectAtIndex:0];
    }
}

- (void)queryMode:(NSThread *)thread
{
    while (YES) {
        if (!self.model) {
            self.model = [self.models objectAtIndex:0];
        }
        [self sendCommand:self.model.queryCmd];
        [NSThread sleepForTimeInterval:4.0];
    }
}

#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:2 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];

    if ((self.mainController)&&([self.mainController isKindOfClass:[SHModeSelectViewController class]])) {
        [(SHModeSelectViewController *)self.mainController setCurrentMode:msg];
    }
    [sock disconnect];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        if (self.mainController) {
            [self.mainController setNetworkState:NO];
        }
        self.networkState = NO;
    } else {
        if (self.mainController) {
            [self.mainController setNetworkState:YES];
        }
        self.networkState = YES;
    }
}

- (void)sendCommand:(NSString *)command
{
    NSError *error = nil;
    NSString *commandSend = [NSString stringWithFormat:@"%@\r\n",command];
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
    socket.command = commandSend;
    [socket connectToHost:self.host onPort:self.port withTimeout:3.0 error:&error];
}

@end
