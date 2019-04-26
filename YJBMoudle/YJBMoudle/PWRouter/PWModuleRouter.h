//
//  JBMoudleRouter.h
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/2.
//  Copyright © 2019 YUJIABO. All rights reserved.
//
//模块调用中间件
#import <Foundation/Foundation.h>
#import "PWModuleProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface PWModuleRouter : NSObject<NSCopying,NSMutableCopying>

/**
 单例路由
 @return 路由实例
 */
+ (instancetype)router;

#pragma mark -获取protocol的实现类的实例对象  推荐模块内解耦使用这种方式
/**
 通过协议获取对应的Module每次调用都会创建一个新的Module对象
 @param protocol 协议
 @return 对应的组件实例（比如ModuleA，ModuleB...）
 */
- (id)interfaceForProtocol:(Protocol *)protocol;

/**
 通过协议获取对应的Module并且缓存Module对象，第一次创建Module对象，后面直接从缓存中取
 @param protocol 协议
 @return 对应的组件实例
 */
- (id)interfaceCacheModuleForProtocol:(Protocol *)protocol;

#pragma mark -通过url调用类的实例方法，类必须要实现PWModuleProtocol协议或实现继承自PWModuleProtocol的协议 适合模块间解耦
/**
 通过url获取module执行action  action不需要传入参数
 @param url module对应协议的名称和action信息的url
 mineProtocol://?action=interfaceViewController
 */
- (id)interfaceActionForURL:(NSString*)url;

/**
 通过url获取module执行action   action需要传入一个参数
 @param url module对应协议的名称和action信息的url
 @param param action只有一个参数
 mineProtocol://?action=presentHomeViewController:
 */
- (id)interfaceActionForURL:(NSString*)url actionParam:(id)param;

/**
 通过url获取module执行action  action需要传入多个参数
 @param url module对应协议的名称和action信息的url
 @param params 执行action传入的参数数组 需要按顺序写
 mineProtocol://?action=combineDictionary:otherDictionary:
 */
- (id)interfaceActionForURL:(NSString*)url actionParams:(NSArray*)params;

#pragma mark -通过url直接调用类的方法(包括实例方法和类方法)  推荐模块间解耦使用这种方式
/**
 通过url获取module执行action  action不需要传入参数
 @param url module类名和action信息的url
 mineModule://?action=interfaceViewController
 或者
 mineModule://?interfaceViewController
 */
- (id)performActionForURL:(NSString*)url;

/**
 通过url获取module执行action   action需要传入一个参数
 @param url module类名和action信息的url
 @param param action需要的参数
 mineModule://?action=presentHomeViewController:
 或者
 mineModule://?presentHomeViewController:
 */
- (id)performActionForURL:(NSString*)url actionParam:(id)param;

/**
 通过url获取module执行action  action需要传入多个参数
 @param url module类名和action信息的url
 @param params 执行action传入的参数数组 需要按顺序写
 mineModule://?action=combineDictionary:otherDictionary:
 或者
mineModule://?combineDictionary:otherDictionary:
 */
- (id)performActionForURL:(NSString*)url actionParams:(NSArray*)params;

@end

NS_ASSUME_NONNULL_END
