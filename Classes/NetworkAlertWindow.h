//
//  NetworkAlertWindow.h
//  WeexEros
//
//  Created by chenyuan on 2018/8/13.
//  Copyright © 2018 benmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkAlertWindow : UIWindow

@property (nonatomic, weak) NSString *status;

//显示
- (void)show;
// 消失
- (void)dismiss;
@end
