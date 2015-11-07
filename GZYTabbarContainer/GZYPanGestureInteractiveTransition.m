//
//  GZYPanGestureInteractiveTransition.m
//  08-GZYTabbarContainer
//
//  Created by gaozy on 15/3/8.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import "GZYPanGestureInteractiveTransition.h"

@interface GZYPanGestureInteractiveTransition ()
{
    BOOL _leftToRightTransition;
}

@end

@implementation GZYPanGestureInteractiveTransition

- (id)initWithGestureRecognizerInView:(UIView *)view recognizedBlock:(void (^)(UIPanGestureRecognizer *))gestureRecognizedBlock
{
    if (self = [super init]) {
        _gestureRecognizedBlock = [gestureRecognizedBlock copy];

        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [view addGestureRecognizer:_panRecognizer];
    }
    return self;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"----UISwipeGestureRecognizer- %ld- %ld",swipe.direction,swipe.state);
    
    if (self.swipeGestureBlock) {
        self.swipeGestureBlock(swipe);
    }
}

- (void)pan:(UIPanGestureRecognizer *) pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.gestureRecognizedBlock(pan);
        NSLog(@"----UIPanGestureRecognizer begin----");
    }else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:pan.view];
        CGFloat fraction = translation.x / CGRectGetWidth(pan.view.bounds);
        if (!_leftToRightTransition) {
            fraction *= -1;
        }
        
        [self updateInteractiveTransition:fraction];
    }else if (pan.state >= UIGestureRecognizerStateEnded)
    {
        if (self.percentComplete > 0.4) {
            [self finishInteractiveTransition];
        }else
        {
            [self cancelInteractiveTransition];
        }
    }
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [super startInteractiveTransition:transitionContext];
    _leftToRightTransition = [_panRecognizer velocityInView:_panRecognizer.view].x > 0;
}

@end
