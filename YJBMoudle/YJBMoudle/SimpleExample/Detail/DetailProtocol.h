//
//  DetailModule.h
//  YJBMoudle
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWModuleProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DetailProtocol <PWModuleProtocol>

- (void)showDetailMessage:(NSString*)message;

- (void)showAlterViewCallBackInViewController:(UIViewController*)viewController;


- (void)noParmarTest;

- (void)oneParmarTest:(NSString*)parmar;

- (void)showhandle:(void(^)(NSString*string))handle oneParmar:(NSDictionary*)one  twoParmar:(NSDictionary*)two;

- (BOOL)returnValueTest;

@end

NS_ASSUME_NONNULL_END
