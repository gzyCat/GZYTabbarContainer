//
//  GZYTabbarContainerController.h
//  08-GZYTabbarContainer
//
//  Created by 高子英 on 15/4/3.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZYTabbarContainerController : UIViewController

@property (nonatomic,copy,readonly) NSArray *viewControllers;
@property (nonatomic,weak) UIViewController *selectedViewController;
@property (nonatomic,assign) CGFloat barHeight;

+ (id)tabbarContainerWithControllers:(NSArray *)viewControllers;
- (id)initWithControllers:(NSArray *)viewControllers;

@end
