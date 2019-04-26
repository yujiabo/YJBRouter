//
//  MeModule.m
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "MeModule.h"
#import "MeViewController.h"
@implementation MeModule
- (id)interfaceViewController
{
    return [[MeViewController alloc]init];
}
- (void)presentHomeViewController:(UIViewController *)vc
{
    [vc presentViewController:[[MeViewController alloc] init] animated:YES completion:nil];
}

- (void)combineDictionary:(NSDictionary*)oneDic otherDictionary:(NSDictionary*)otherDic
{
    NSMutableDictionary *combineDic = [NSMutableDictionary dictionaryWithDictionary:oneDic];
    [combineDic addEntriesFromDictionary:otherDic];
    
    NSLog(@"调用传入多参数的action成功---%@",combineDic);
    
}
@end
