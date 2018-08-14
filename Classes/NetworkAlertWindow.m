//
//  NetworkAlertWindow.m
//  WeexEros
//
//  Created by chenyuan on 2018/8/13.
//  Copyright © 2018 benmu. All rights reserved.
//

#import "NetworkAlertWindow.h"
#import <BMMediatorManager.h>
#import <BMDebugManager.h>
#import <BMResourceManager.h>
#import <BMBaseViewController.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface NetworkViewController : UIViewController

@property (nonatomic,strong) NetworkAlertWindow *window;

@end

@implementation NetworkViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.window.status isEqualToString:@"NotReachable"]) {
        [self.window show];
    }else if([self.window.status isEqualToString:@"OK"]){
        [self.window dismiss];
    }
}

@end

@interface NetworkAlertWindow ()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;
@property (nonatomic, strong) NetworkViewController *networkVC;

@end

@implementation NetworkAlertWindow

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self watchNetworkStatus];
    }
    return self;
}

- (void)show
{
    if(self.networkVC == nil){
        Boolean isIphone5 = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO;
        Boolean isIphoneX = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
        
        float scale = isIphone5 ? 0.8 : 1;
        float top = isIphoneX ? 100 : 70;
        
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 364*scale)/2, top, 364*scale, 48*scale);
        
        //2. 创建一个控制器，赋值为window的根控制器
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [btn setImage:[UIImage imageNamed:@"network_error"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
        UIViewController *VC = [[UIViewController alloc] init];
        [VC.view addSubview:btn];
        VC.view.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.rootViewController = VC;
    }
    
    //3. 显示窗口
    [self makeKeyAndVisible];
}

/** 监听网络状态 */
- (void)watchNetworkStatus
{
    self.reachability = [AFNetworkReachabilityManager manager];
    [self.reachability startMonitoring];
    __weak __typeof__(self) weakSelf = self;
    [self.reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            weakSelf.status = @"NotReachable";
            [weakSelf show];
        }else{
            weakSelf.status = @"OK";
            [weakSelf dismiss];
        }
        
    }];
}

- (void)gotoSetting{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"network_setting" ofType:@"html"];
    NSURL* url = [NSURL  fileURLWithPath:path];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];
    self.networkVC = [[NetworkViewController alloc] init];
    self.networkVC.window = self;
    self.networkVC.title = @"未能连接到互联网";
    [self.networkVC.view addSubview:webView];
    [[BMMediatorManager shareInstance].currentViewController.navigationController pushViewController:self.networkVC animated:YES];
    self.hidden = YES;
}

//window消失
- (void)dismiss {
    self.hidden = YES;
    [self refreshWeex];
}

- (void)refreshWeex
{
    //刷新widgetJs
    [BMResourceManager sharedInstance].bmWidgetJs = nil;
    
    //检查js中介者是否加载成功
    [[BMMediatorManager shareInstance] loadJSMediator:NO];
    
    UIViewController* controller =  [[BMMediatorManager shareInstance] currentViewController];
    if ([controller isKindOfClass:[BMBaseViewController class]]) {
        [(BMBaseViewController*)controller refreshWeex];
    }
}

@end


