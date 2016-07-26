//
//  AppActiveStateBase.m
//  LANConnectLib
//
//  Created by liangjiajian_mac on 16/7/25.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AppActiveStateBase.h"
#import <UIKit/UIKit.h>

@implementation AppActiveStateBase {
    BOOL registerListener;
}

- (void)registerStateListener {
    if(registerListener){
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    registerListener = YES;
}

- (void)resignStateListener {
    if(!registerListener){
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    registerListener = NO;
}

- (void)becomeActive {
    // overrride
}

- (void)resignActive {
    // overrride
}

-(void)dealloc {
    [self resignStateListener];
}

@end
