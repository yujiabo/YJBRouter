//
//  HomeModule.m
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "HomeModule.h"
#import "HomeViewController.h"

@implementation HomeModule
@synthesize paramterForHome;

- (id)interfaceViewController
{
    return [[HomeViewController alloc]init];
}


@end
