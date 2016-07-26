//
//  ViewController.m
//  test
//
//  Created by liangjiajian_mac on 16/7/19.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "ViewController.h"
#import <LANConnectLib/LANConnectLib.h>

@interface ViewController () <UDPDataDelegate, TCPDataDelegate, TCPServerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *outputText;

@end

@implementation ViewController{
//    UDPReceiver *receiver;
//    UDPSender *sender;
}

- (IBAction)testClicked:(UIButton *)btn {
    [[SnifferManager shareInstance] startSniffing:^(NSArray *terminals) {
        NSString *newString = [NSString stringWithFormat:@"terminals=%@", terminals];
        [self printString:newString];
    }];
    
}

- (IBAction)btn2Clicked:(UIButton *)sender {
//    receiver = [[UDPReceiver alloc]initWithLocalPort:8080];
//    receiver.delegate = self;
}

- (void)onReceiveData:(NSData *)data fromIP:(NSString *)ip port:(short)port error:(NSError *)error {
    NSString *newString = [NSString stringWithFormat:@"udp data:%@, from %@:%d error=%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding], ip, port, error];
    [self printString:newString];
}

- (void)acceptConnection:(TCPAcceptSection*) section {
}

- (void)onReceiveData:(NSData*)data {
    NSString *newString = [NSString stringWithFormat:@"tcp data:%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    [self printString:newString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
//    sender = [[UDPSender alloc]initWithLocalPort:8081];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printString:(NSString*)string{
    NSLog(@"%@", string);
    NSString *string2 = _outputText.text;
    if(string2 && string2.length > 0){
        string2 = [NSString stringWithFormat:@"%@\n%@", string, string2];
    }else{
        string2 = string;
    }
    [_outputText performSelectorOnMainThread:@selector(setText:) withObject:string2 waitUntilDone:NO];
}
@end
