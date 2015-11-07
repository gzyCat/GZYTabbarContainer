//
//  GZYPanGestureInteractiveTransition.h
//  08-GZYTabbarContainer
//
//  Created by gaozy on 15/3/8.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWPercentDrivenInteractiveTransition.h"

@interface GZYPanGestureInteractiveTransition : AWPercentDrivenInteractiveTransition

@property (nonatomic,strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeLeftRecognizer;

@property (nonatomic, copy) void (^gestureRecognizedBlock)(UIPanGestureRecognizer *recognizer);

- (id)initWithGestureRecognizerInView:(UIView *)view recognizedBlock:(void (^)(UIPanGestureRecognizer *recognizer))gestureRecognizedBlock;

@property (nonatomic,copy) void (^swipeGestureBlock)(UISwipeGestureRecognizer *recognizer);


@end
