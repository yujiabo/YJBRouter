//
//  DetailModule.m
//  YJBMoudle
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "DetailModule.h"
@interface DetailModule()<UIAlertViewDelegate>

@end
@implementation DetailModule
@synthesize callbackBlock;

- (void)showDetailMessage:(NSString *)message
{
    NSLog(@"---------%@",message);
}
- (void)showAlterViewCallBackInViewController:(UIViewController*)viewController
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"测试回调函数" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.callbackBlock) {
            self.callbackBlock(@"1234");
        }
    }];
    [alter addAction:sureAction];
    
    [viewController presentViewController:alter animated:YES completion:nil];
}


- (void)noParmarTest
{
    NSLog(@"调用noParmarTest函数成功");
}

- (void)oneParmarTest:(NSString*)parmar
{
    NSLog(@"调用oneParmarTest:函数传入的参数是%@",parmar);
}

- (void)showhandle:(void(^)(NSString*string))handle oneParmar:(NSDictionary*)one  twoParmar:(NSDictionary*)two
{
    NSLog(@"调用showhandle: oneParmar: twoParmar:函数传入的参数是%@,%@",one,two);
    //handle(@"9999");
}

- (BOOL)returnValueTest
{
    return YES;
}

+ (void)testClassMethod
{
    NSLog(@"调用类方法成功");
}
@end
