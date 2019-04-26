//
//  JBMoudleRouter.m
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/2.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "PWModuleRouter.h"
#import <objc/runtime.h>

@interface PWModuleRouter()

@property (nonatomic, strong)NSCache *classMapCache;

@property (nonatomic, strong)NSMutableDictionary *moduleMapCache;

@end

@implementation PWModuleRouter

static PWModuleRouter *_router;
#pragma mark - 单例
+ (instancetype)router {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [[self alloc]init];
    });
    return _router;
}

+ (void)load
{
    // 异步加载所有的class到内存中
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[PWModuleRouter router] loadClassesConfirmToProtocol:@protocol(PWModuleProtocol)];
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.classMapCache = [[NSCache alloc] init];
        self.moduleMapCache = [[NSMutableDictionary alloc]initWithCapacity:0];
        self.classMapCache.countLimit = 50;//限制缓存的数据数目,目的是控制内存占用
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_router == nil) {
            _router = [super allocWithZone:zone];
        }
    });
    return _router;
}

- (id)copyWithZone:(NSZone *)zone {
    return _router;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _router;
}

#pragma mark - protocol-class 相关方法
- (id)interfaceForProtocol:(Protocol *)protocol {
    
    Class class = [self findClassForProtocol:protocol];
    return [[class alloc]init];
}

- (id)interfaceCacheModuleForProtocol:(Protocol *)protocol
{
    NSString *key = NSStringFromProtocol(protocol);
    id instance = [self.moduleMapCache objectForKey:key];
    if (instance) {
        return instance;
    }
    Class class = [self findClassForProtocol:protocol];
    instance = [[class alloc]init];
    [self.moduleMapCache setObject:instance forKey:key];
    return instance;
}

#pragma mark -通过url调用porotocol的实现类方法
- (id)interfaceActionForURL:(NSString*)url
{
    url= [self removeSpaceAndNewline:url];
    if (![self validateUrl:url]) {
        NSLog(@"组件调用异常⚠️:%@%@",@"无效的url",url);
        return nil;
    }
    if (![self validateActionUrl:url]) {
        url = [url stringByReplacingOccurrencesOfString:@"://?" withString:@"://?action="];
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    Protocol *p = objc_getProtocol(URL.scheme.UTF8String);
   return [self performActionParmar:nil classConfirm:p isMultiple:NO forUrl:url];
}

- (id)interfaceActionForURL:(NSString*)url actionParam:(id)param
{
    url= [self removeSpaceAndNewline:url];
    
    if (![self validateUrl:url]) {
        NSLog(@"组件调用异常⚠️:%@%@",@"无效的url",url);
        return nil;
    }
    if (![self validateActionUrl:url]) {
        url = [url stringByReplacingOccurrencesOfString:@"://?" withString:@"://?action="];
    }
    NSURL *URL = [NSURL URLWithString:url];
    Protocol *p = objc_getProtocol(URL.scheme.UTF8String);
  
    if (!param) {
        NSLog(@"组件调用异常⚠️:%@",@"targetPerformActionForURL:actionParam: 参数param不能为空");
        return nil;
    }

    return [self performActionParmar:param classConfirm:p isMultiple:NO forUrl:url];
}

- (id)interfaceActionForURL:(NSString*)url actionParams:(NSArray*)params
{
    url= [self removeSpaceAndNewline:url];
    
    if (![self validateUrl:url]) {
        NSLog(@"组件调用异常⚠️:%@%@",@"无效的url",url);
        return nil;
    }
    if (![self validateActionUrl:url]) {
        url = [url stringByReplacingOccurrencesOfString:@"://?" withString:@"://?action="];
    }
    if (!params||![params isKindOfClass:[NSArray class]]||params.count==0) {
        NSLog(@"组件调用异常⚠️:%@",@"interfaceActionForURL: actionParams: 参数params不能为空并且必须是数组类型");
        return nil;
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    Protocol *p = objc_getProtocol(URL.scheme.UTF8String);
    return [self performActionParmar:params classConfirm:p isMultiple:YES forUrl:url];
}

#pragma mark - 通过url直接调用类的方法
- (id)performActionForURL:(NSString*)url
{
   url= [self removeSpaceAndNewline:url];
    
    if (![self validateUrl:url]) {
        NSLog(@"组件调用异常⚠️:%@%@",@"无效的url",url);
        return nil;
    }
    if (![self validateActionUrl:url]) {
        url = [url stringByReplacingOccurrencesOfString:@"://?" withString:@"://?action="];
    }
   return [self performActionParmar:nil classConfirm:nil isMultiple:NO forUrl:url];
}

- (id)performActionForURL:(NSString*)url actionParam:(id)param
{
    url= [self removeSpaceAndNewline:url];
    
    if (![self validateUrl:url]) {
        NSLog(@"组件调用异常⚠️:%@%@",@"无效的url",url);
        return nil;
    }
    if (![self validateActionUrl:url]) {
        url = [url stringByReplacingOccurrencesOfString:@"://?" withString:@"://?action="];
    }
    if (!param) {
        NSLog(@"组件调用异常⚠️:%@",@"performActionForURL:actionParam: 参数param不能为空");
        return nil;
    }
   return [self performActionParmar:param classConfirm:nil isMultiple:NO forUrl:url];
}

- (id)performActionForURL:(NSString*)url actionParams:(NSArray*)params
{
    url= [self removeSpaceAndNewline:url];
    
    if (![self validateUrl:url]) {
        NSLog(@"组件调用异常⚠️:%@%@",@"无效的url",url);
        return nil;
    }
    if (![self validateActionUrl:url]) {
        url = [url stringByReplacingOccurrencesOfString:@"://?" withString:@"://?action="];
    }
    
    if (!params||![params isKindOfClass:[NSArray class]]||params.count==0) {
        NSLog(@"组件调用异常⚠️:%@",@"performActionForURL: actionParams: 参数params不能为空并且必须是数组类型");
        return nil;
    }
    return [self performActionParmar:params classConfirm:nil isMultiple:YES forUrl:url];
}

#pragma mark - Private

- (id)performActionParmar:(id)parmar classConfirm:(Protocol *)protocol isMultiple:(BOOL)multiple forUrl:(NSString*)url
{
    NSURL *URL = [NSURL URLWithString:url];
    NSString *className = [NSString stringWithFormat:@"%s",URL.scheme.UTF8String];
    
    __block NSString *actionString = @"";
    NSURLComponents *cp = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    [cp.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==0&&[obj.name isEqualToString:@"action"]){
            actionString = obj.value;
        }
    }];
    
    Class class = NSClassFromString(className);
    if (protocol) {
        class = [self findClassForProtocol:protocol];
    }
   
    SEL action = NSSelectorFromString(actionString);
    if ([class respondsToSelector:action]) {
        return [self safePerformAction:action target:class params:parmar];
    }
    
    id module = [[class alloc]init];
    if (!module) {
        if (protocol){
            NSString *reason = [NSString stringWithFormat: @"URL:%@找不到协议%@的实现类", url,NSStringFromProtocol(protocol)];
            NSLog(@"组件调用异常⚠️:%@",reason);
        }
        else{
            NSString *reason = [NSString stringWithFormat: @"URL:%@找不到名称为%@的类", url,className];
            NSLog(@"组件调用异常⚠️:%@",reason);
        }
        return nil;
    }
    
    if (![module respondsToSelector:action]) {
        NSString *reason = [NSString stringWithFormat: @"URL:%@类%@没有实现%@方法",url,NSStringFromClass(class),actionString];
        NSLog(@"组件调用异常⚠️:%@",reason);
        return nil;
    }
    
     return [self safePerformAction:action target:module params:parmar];
}


- (Class<PWModuleProtocol>)findClassForProtocol:(Protocol*)protocol {
    
    NSString *key = NSStringFromProtocol(protocol);
    Class cacheClass = [self.classMapCache objectForKey:key];
    if (cacheClass) {
        //已经缓存的协议实现类
        return cacheClass;
    } else {
        //未缓存的协议实现类
        Class<PWModuleProtocol> responseClass = [self assertForMoudleWithProtocol:protocol];
        return responseClass;
    }
    return nil;
}

- (Class)classForProtocol:(Protocol *)protocol {
    
    unsigned int classCount;
    Class* classList = objc_copyClassList(&classCount);
    int i;
    Class thisClass = nil;
    for (i=0; i<classCount; i++) {
        const char *className = class_getName(classList[i]);
        Class tempClass = objc_getClass(className);
        if (class_conformsToProtocol(tempClass, protocol)) {
            thisClass = tempClass;
            break;
        }
    }
    free(classList);
    return thisClass;
}

- (Class)assertForMoudleWithProtocol:(Protocol *)p {
    
    Class thisClass = [self classForProtocol:p];
    if (!thisClass) {
        NSString *protocolName = NSStringFromProtocol(p);
        NSString *reason = [NSString stringWithFormat: @"找不到协议 %@ 对应的接口实现类", protocolName];
        NSLog(@"组件异常⚠️:%@",reason);
        return nil;
    }
    return thisClass;
}

- (void)loadClassesConfirmToProtocol:(Protocol *)protocol {
    unsigned int classCount;
    Class* classList = objc_copyClassList(&classCount);
    int i;
    for (i=0; i<classCount; i++) {
        const char *className = class_getName(classList[i]);
        Class thisClass = objc_getClass(className);
        if (class_conformsToProtocol(thisClass, protocol)) {
            const char *protocolName = protocol_getName([self protroclForClass:thisClass]);
            NSString *pn = [NSString stringWithUTF8String:protocolName];
            [self.classMapCache setObject:thisClass forKey:pn];
        }
    }
    free(classList);
}
//取实现类的协议列表的第一个协议为路由协议
- (Protocol*)protroclForClass:(Class)cs
{
    unsigned int protocalCount;
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(cs, &protocalCount);
    Protocol *myProtocal = protocolList[0];
    free(protocolList);
    return myProtocal;
}


/**
 Action最终执行的核心代码
 @param action 方法函数
 @param target 执行的目标对象
 @param params 传入的参数
 @return 方法返回值
 */
- (id)safePerformAction:(SEL)action target:(id)target params:(id)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    NSArray *coms = [NSStringFromSelector(action) componentsSeparatedByString:@":"];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        NSInteger pcount = coms.count-1;
        if (pcount==0) {
            //不需要参数
        }
        else if (pcount==1){
            //需要一个参数
            if(params) [invocation setArgument:&params atIndex:2];
        }
        else{
            //需要多个参数
            if (params&&[params isKindOfClass:[NSArray class]]) {
                NSArray *multipleParams = (NSArray*)params;
                
                for (int i = 2; i<pcount+2; i++)
                {
                    if ((i-2)>=multipleParams.count) {
                        break;
                    }
                    id param = multipleParams[i-2];
                    if (pcount>(i-2)) {
                        if(param) [invocation setArgument:&param atIndex:i];
                    }
                }
            }
        }
       
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        NSInteger pcount = coms.count-1;
        if (pcount==0) {
            //不需要参数
        }
        else if (pcount==1){
            //需要一个参数
            if(params) [invocation setArgument:&params atIndex:2];
        }
        else{
            //需要多个参数
            if (params&&[params isKindOfClass:[NSArray class]]) {
                NSArray *multipleParams = (NSArray*)params;
                
                for (int i = 2; i<pcount+2; i++)
                {
                    if ((i-2)>=multipleParams.count) {
                        break;
                    }
                    id param = multipleParams[i-2];
                    if (pcount>(i-2)) {
                        if(param) [invocation setArgument:&param atIndex:i];
                    }
                }
            }
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        NSInteger pcount = coms.count-1;
        if (pcount==0) {
            //不需要参数
        }
        else if (pcount==1){
            //需要一个参数
            if(params) [invocation setArgument:&params atIndex:2];
        }
        else{
            //需要多个参数
            if (params&&[params isKindOfClass:[NSArray class]]) {
                NSArray *multipleParams = (NSArray*)params;
                
                for (int i = 2; i<pcount+2; i++)
                {
                    if ((i-2)>=multipleParams.count) {
                        break;
                    }
                    id param = multipleParams[i-2];
                    if (pcount>(i-2)) {
                        if(param) [invocation setArgument:&param atIndex:i];
                    }
                }
            }
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        NSInteger pcount = coms.count-1;
        if (pcount==0) {
            //不需要参数
        }
        else if (pcount==1){
            //需要一个参数
            if(params) [invocation setArgument:&params atIndex:2];
        }
        else{
            //需要多个参数
            if (params&&[params isKindOfClass:[NSArray class]]) {
                NSArray *multipleParams = (NSArray*)params;
                
                for (int i = 2; i<pcount+2; i++)
                {
                    if ((i-2)>=multipleParams.count) {
                        break;
                    }
                    id param = multipleParams[i-2];
                    if (pcount>(i-2)) {
                        if(param) [invocation setArgument:&param atIndex:i];
                    }
                }
            }
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        NSInteger pcount = coms.count-1;
        if (pcount==0) {
            //不需要参数
        }
        else if (pcount==1){
            //需要一个参数
            if(params) [invocation setArgument:&params atIndex:2];
        }
        else{
            //需要多个参数
            if (params&&[params isKindOfClass:[NSArray class]]) {
                NSArray *multipleParams = (NSArray*)params;
                
                for (int i = 2; i<pcount+2; i++)
                {
                    if ((i-2)>=multipleParams.count) {
                        break;
                    }
                    id param = multipleParams[i-2];
                    if (pcount>(i-2)) {
                        if(param) [invocation setArgument:&param atIndex:i];
                    }
                }
            }
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}
//去掉字符串中的所有空格和换行
- (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

- (BOOL)validateUrl:(NSString *)url
{
    NSString* urlRex=@"[a-zA-z]+://\?[^\\s]*";
    NSPredicate *urlPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRex];
    return [urlPre evaluateWithObject:url];
}

- (BOOL)validateActionUrl:(NSString *)url
{
    NSString* urlRex=@"[a-zA-z]+://\?action=[^\\s]*";
    NSPredicate *urlPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRex];
    return [urlPre evaluateWithObject:url];
}
@end
