//
//  GPAnimator.m
//  08-GZYTabbarContainer
//
//  Created by gaozy on 15/3/3.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import "GPAnimator.h"

@implementation GPAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [self animateTransitionWithTranslation:transitionContext];
}

- (void)animateTransitionWithTranslation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];    
    
    BOOL goingRight = ([transitionContext initialFrameForViewController:toViewController].origin.x < [transitionContext finalFrameForViewController:toViewController].origin.x);
    
    UIView *containerView = [transitionContext containerView];
    
    CGFloat travelDistance = containerView.bounds.size.width ;
    travelDistance = goingRight ? travelDistance : -travelDistance;
    [containerView insertSubview:toViewController.view atIndex:0];
    
    NSLog(@"toViewController.view.center %@",NSStringFromCGPoint(toViewController.view.center));
    
//    CGFloat viewY = toViewController.view.center.y ;
    CGPoint center = CGPointMake(containerView.center.x, toViewController.view.center.y);
    
    CGPoint fromCenter =  CGPointMake(center.x+travelDistance, center.y);
    CGPoint toCenter =  CGPointMake(center.x-travelDistance,  center.y);
    
    NSLog(@" containerView frame %@ center %@ testCenter %@",NSStringFromCGRect(containerView.frame),NSStringFromCGPoint(center),NSStringFromCGPoint(center));
    
    toViewController.view.center = toCenter;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.center = fromCenter;
        toViewController.view.center = center;
        
    } completion:^(BOOL finished) {
        fromViewController.view.center = center;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}


- (void)animateTransitionWithScale:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    //设置viewControllers 转场动画
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        //fromViewController.view.alpha = 0;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
