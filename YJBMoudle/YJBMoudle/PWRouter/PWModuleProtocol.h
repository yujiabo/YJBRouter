//
//  JBMoudleProtocol.h
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/2.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

//此类为协议基础类
/***
 协议写法注意事项:
 1.一个协议只能对应一个模块实现类，不能对应多个不然会随机调用其中一个实现类
 2.模块实现类遵循的组件化协议必须是放在第一位 如:@interface HomeModule : NSObject<MoudleHome,NSCopying>
 3.模块协议必须遵循JBMoudleProtocol协议
 ***/

#define PWRouter  [PWModuleRouter router]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PWModuleRouter.h"

typedef void(^PWCallBackBlock)(id parameter);
NS_ASSUME_NONNULL_BEGIN
#pragma mark -基础组件 这里可以定义一些公共的api和属性
@protocol PWModuleProtocol <NSObject>
@optional;
//回调
@property (nonatomic, copy) PWCallBackBlock callbackBlock;

@end

NS_ASSUME_NONNULL_END
