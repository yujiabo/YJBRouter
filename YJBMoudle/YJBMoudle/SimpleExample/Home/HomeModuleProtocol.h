//
//  HomeModuleProtocol.h
//  YJBMoudle
//
//  Created by YUJIABO on 2019/4/7.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeModuleProtocol <NSObject>

@property (nonatomic, copy)NSString *paramterForHome;

- (id)interfaceViewController;

@end

NS_ASSUME_NONNULL_END
