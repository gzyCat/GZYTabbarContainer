//
//  GZYTabbarContainerController.m
//  08-GZYTabbarContainer
//
//  Created by gaozy on 15/4/3.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import "GZYTabbarContainerController.h"
#import "GPTabbar.h"
#import "GPAnimator.h"
#import "GZYPanGestureInteractiveTransition.h"

static CGFloat const kBarHeight = 44;


@interface PrivateTransitionContext : NSObject<UIViewControllerContextTransitioning>

@property (nonatomic,assign,getter=isAnimated) BOOL animated;
@property (nonatomic,assign,getter=isInteractive) BOOL interactive;
@property (nonatomic,copy) void (^completionBlock)(BOOL didComplete);

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight;

@end


@interface GZYTabbarContainerController ()<GPTabbarDelegate>

@property (nonatomic,weak) UIView *privateContainerView;
@property (nonatomic,weak) GPTabbar *privateTabbarView;
@property (nonatomic,strong) GZYPanGestureInteractiveTransition *defaultInteractionController;

@end

@implementation GZYTabbarContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    
    [self.privateTabbarView setSelectedButtonAtIndex:0];
}

- (void)updateUI
{
    GPTabbar *tabbarView = [GPTabbar tabbar];
    self.privateTabbarView = tabbarView;
    self.privateTabbarView.backgroundColor = [UIColor redColor];
    self.privateTabbarView.delegate = self;
    
    UIView *containerView = [[UIView alloc] init];
    self.privateContainerView = containerView;
    self.privateContainerView.backgroundColor = [UIColor blueColor];
    
    self.privateTabbarView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.barHeight);
    self.privateContainerView.frame = CGRectMake(0, self.barHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.barHeight-self.tabBarController.tabBar.frame.size.height);
    
    NSLog(@"tabbar height %f",self.tabBarController.tabBar.frame.size.height);
    
    [self.view addSubview:self.privateContainerView];
    [self.view addSubview:self.privateTabbarView];
    [self _addChildViewControllerButtons];
    
    [self addGestureRecognizerInteraction];
}

- (void)addGestureRecognizerInteraction
{
    __weak typeof(self) wsself = self;
    self.defaultInteractionController = [[GZYPanGestureInteractiveTransition alloc] initWithGestureRecognizerInView:self.privateContainerView recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        
        BOOL leftToRight = [recognizer velocityInView:recognizer.view].x > 0;
        NSInteger currentVCIndex = [self.privateTabbarView selectIndex];
        NSLog(@"currentVCIndex----%ld",currentVCIndex);
        if (leftToRight && currentVCIndex > 0 ) {
            [self.privateTabbarView setSelectedButtonAtIndex:currentVCIndex -1];
            
        }else if(!leftToRight && currentVCIndex != self.viewControllers.count-1)
        {
            [self.privateTabbarView setSelectedButtonAtIndex:currentVCIndex + 1];
        }
        
    }];
    
    
    [self.defaultInteractionController setSwipeGestureBlock:^(UISwipeGestureRecognizer *recognizer) {
        
        NSInteger currentVCIndex = [wsself.privateTabbarView selectIndex];
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && currentVCIndex > 0) {
            [wsself.privateTabbarView setSelectedButtonAtIndex:currentVCIndex -1];
            
        }else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && currentVCIndex != self.viewControllers.count-1){
            [wsself.privateTabbarView setSelectedButtonAtIndex:currentVCIndex + 1];
            
        }
    }];
}

- (CGFloat)barHeight
{
    if (_barHeight == 0) {
        _barHeight = kBarHeight;
    }
    return _barHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GPTabbarDelegate

- (void)tabbarSelected:(GPTabbar *)tabbar atIndex:(NSInteger)index item:(UIButton *)btn
{
    UIViewController *viewController = self.viewControllers[index];
    
    NSLog(@"privateContainerView frame %@ center %@",NSStringFromCGRect(self.privateContainerView.frame),NSStringFromCGPoint(self.privateContainerView.center));
    // 动画切换
    [self transitionToChildViewController:viewController];
}

- (void)transitionToChildViewController:(UIViewController *)toViewController
{
    UIViewController *fromViewController = [self.childViewControllers count] > 0 ? self.childViewControllers[0] :nil;
    
    if (fromViewController == toViewController || ![self isViewLoaded]) {
        return;
    }
    
    UIView *toView = toViewController.view;
    toView.frame = self.privateContainerView.bounds;
    
    NSLog(@"toView.frame %@ center %@ ",NSStringFromCGRect(toView.frame),NSStringFromCGPoint(toView.center));
    
    [fromViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:toViewController];
    
    // 如果是第一个则直接添加不进行转场动画
    if (!fromViewController) {
        
        [self.privateContainerView addSubview:toView];
        [toViewController didMoveToParentViewController:self];
        [self _updatePrivateTabbarView:toViewController];
        
        return;
    }
    
    [self.privateContainerView addSubview:toView];
    GPAnimator *animator = [[GPAnimator alloc] init];
    
    // 根据index的大小，判断转场出现的位置
    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIndex = [self.viewControllers indexOfObject:toViewController];
    
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:toIndex > fromIndex];
    
    id<UIViewControllerInteractiveTransitioning> interactionController = [self _interactionControllerForAnimator:animator];
    
    transitionContext.animated = YES;
    transitionContext.interactive = (interactionController != nil) ;
    
    [transitionContext setCompletionBlock:^(BOOL didComplete) {
        if (didComplete) {
            [fromViewController.view removeFromSuperview];
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:self];
            [self _updatePrivateTabbarView:toViewController];
        } else {
            [toViewController.view removeFromSuperview];
            [toViewController removeFromParentViewController];
            
            NSLog(@"setCompletionBlock cannel......");
        }
        
        if ([animator respondsToSelector:@selector(animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        self.privateTabbarView.userInteractionEnabled = YES;
    }];
    
    //在动画运动期间禁止button 使用
    self.privateTabbarView.userInteractionEnabled = NO;
    
    if ([transitionContext isInteractive]) {
        [interactionController startInteractiveTransition:transitionContext];
    } else {
        [animator animateTransition:transitionContext];
    }
}

- (void) _updatePrivateTabbarView:(UIViewController *)toViewController
{
    self.privateTabbarView.selectIndex = [self.viewControllers indexOfObject:toViewController];
}

- (id<UIViewControllerInteractiveTransitioning>)_interactionControllerForAnimator:(id<UIViewControllerAnimatedTransitioning>)animation {
    
    if (self.defaultInteractionController.panRecognizer.state == UIGestureRecognizerStateBegan) {
        self.defaultInteractionController.animator = animation;
        return self.defaultInteractionController;
    } else {
        return nil;
    }
}


#pragma mark -  根据子视图上的信息设置button上的显示信息

- (void)_addChildViewControllerButtons
{
    NSMutableArray *btnArray = @[].mutableCopy;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *icon = [[childViewController tabBarItem].image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn setImage:icon forState:UIControlStateNormal];
        
        UIImage *selectIcon = [[childViewController tabBarItem].selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn setImage:selectIcon forState:UIControlStateSelected];
        
        [btn setTitle:childViewController.title forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [btnArray addObject:btn];
        
    }];
    [self.privateTabbarView setButtonItems:btnArray];
}

#pragma mark - init controllers
+ (id)tabbarContainerWithControllers:(NSArray *)viewControllers
{
    return [[self alloc] initWithControllers:viewControllers];
}

- (id)initWithControllers:(NSArray *)viewControllers
{
    NSParameterAssert([viewControllers count] > 0);
    if (self = [super init]) {
        _viewControllers = viewControllers.copy;
        [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            viewController.automaticallyAdjustsScrollViewInsets = NO;
        }];
    }
    return self;
}


@end


@interface PrivateTransitionContext ()

@property (nonatomic,strong) NSDictionary *privateViewControllers;
@property (nonatomic,assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, weak) UIView *containerView;

@property (nonatomic,assign)CGRect privateDisapperingFromRect;
@property (nonatomic,assign)CGRect privateApperingFromRect;

@property (nonatomic,assign) CGRect privateDisapperingToRect;
@property (nonatomic,assign) CGRect privateApperingToRect;

@property (nonatomic, assign) BOOL transitionWasCancelled;
@end


@implementation PrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight
{
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.  %d %d",[fromViewController isViewLoaded],(fromViewController.view.superview == nil));
    
    if (self = [super init]) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        
        self.privateViewControllers = @{UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController};
        
        CGFloat distance = goingRight ? -self.containerView.bounds.size.width : self
        .containerView.bounds.size.width;
        
        self.privateDisapperingFromRect = self.privateApperingToRect = self.containerView.bounds;
        
        self.privateDisapperingToRect = CGRectOffset(self.containerView.bounds, distance, 0);
        self.privateApperingFromRect = CGRectOffset(self.containerView.bounds, -distance, 0);
    }
    return self;
}

// 开始是出现frame
- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisapperingFromRect;
    }else
    {
        return self.privateApperingFromRect;
    }
}

// 将要结束的frame
- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return  self.privateDisapperingToRect;
    }else{
        return self.privateApperingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    return self.privateViewControllers[key];
}

// 完成后回调函数
- (void)completeTransition:(BOOL)didComplete
{
    if (self.completionBlock) {
        self.completionBlock(didComplete);
    }
}

//- (BOOL)transitionWasCancelled{ return NO;}

- (void)updateInteractiveTransition:(CGFloat)percentComplete{};
- (void)finishInteractiveTransition{ self.transitionWasCancelled = NO;};
- (void)cancelInteractiveTransition{
    self.transitionWasCancelled = YES;
    // 如果为取消则将fromViewControll的frame还原
    UIView * fromView= [self containerView].subviews.lastObject;
    CGPoint center = CGPointMake(self.containerView.center.x, fromView.center.y);
    fromView.center = center;
};


@end
