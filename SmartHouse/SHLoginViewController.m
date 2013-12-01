//
//  ViewController.m
//  SmartHouse
//
//  Created by Roc on 13-8-13.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHLoginViewController.h"
#import "SHRoomsListViewController.h"

@implementation SHLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loginCheck
{
    [self.passwordField resignFirstResponder];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (password) {
        if ([password isEqualToString:[self.passwordField text]]) {
            SHRoomsListViewController *controller = [[SHRoomsListViewController alloc] initWithNibName:nil bundle:nil];
            controller.backController = self;
            [self presentViewController:controller animated:YES completion:^(void){
                [self.passwordField setText:nil];
                [self.passwordField setBackground:[UIImage imageNamed:@"input_box_iphone"]];
                [self.passwordField setPlaceholder:@"请输入密码"];
            }];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"密码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
        }
    } else {
        if ([[self.passwordField text] isEqualToString:@"0000"]) {
            SHRoomsListViewController *controller = [[SHRoomsListViewController alloc] initWithNibName:nil bundle:nil];
            controller.backController = self;
            [self presentViewController:controller animated:YES completion:^(void){
                [self.passwordField setText:nil];
                [self.passwordField setBackground:[UIImage imageNamed:@"input_box_iphone"]];
                [self.passwordField setPlaceholder:@"请输入密码"];
            }];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"密码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, App_Height)];
    [self.imageView setImage:[UIImage imageNamed:@"login_bg_iphone"]];
    
    [self.view addSubview:self.imageView];
    
    self.loginbox = [[UIImageView alloc] initWithFrame:CGRectMake(42.0, 80.0, 236.0, 170.0)];
    [self.loginbox setImage:[UIImage imageNamed:@"login_box_iphone"]];
    [self.imageView addSubview:self.loginbox];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch)];
    [gesture setNumberOfTouchesRequired:1];
    [gesture setNumberOfTapsRequired:1];
    [gesture setDelegate:self];
    [self.view addGestureRecognizer:gesture];
    
	loginLabel = [[UILabel alloc] init];
    [loginLabel setBackgroundColor:[UIColor clearColor]];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [loginLabel setTextColor:[UIColor colorWithRed:0.694 green:0.278 blue:0.020 alpha:1.0]];
    [loginLabel setText:@"智能家居系统"];
    [loginLabel sizeToFit];
    [loginLabel setFrame:CGRectMake(42.0, 93.0, 236.0, 20.0)];
    [self.view addSubview:loginLabel];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(65.0, 142.0, 190.0, 32.0)];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setPlaceholder:@"请输入密码"];
    [self.passwordField setFont:[UIFont systemFontOfSize:12.0]];
    [self.passwordField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.passwordField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.passwordField setTextAlignment:NSTextAlignmentCenter];
    [self.passwordField setDelegate:self];
    [self.passwordField setBackground:[UIImage imageNamed:@"input_box_iphone"]];
    [self.view addSubview:self.passwordField];
    
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_iphone_normal"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_iphone_pressed"] forState:UIControlStateHighlighted];
    [self.loginButton sizeToFit];
    [self.loginButton setFrame:CGRectMake(64.5, 190.0, 193.0, 37.5)];
    [self.loginButton addTarget:self action:@selector(loginCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.passwordField setPlaceholder:@""];
    [self.passwordField setBackground:[UIImage imageNamed:@"input_box_focused_iphone"]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)onTouch
{
    [self.passwordField resignFirstResponder];
    if (self.passwordField.text.length == 0) {
        [self.passwordField setBackground:[UIImage imageNamed:@"input_box_iphone"]];
        [self.passwordField setPlaceholder:@"请输入密码"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
