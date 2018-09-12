//
//  TodayTopTransition.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/12.
//

#import "TodayTopTransition.h"

@implementation TodayTopTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return .8f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    toView.layer.transform = CATransform3DMakeTranslation(screenWidth,0,0);
    [UIView animateWithDuration:.5 animations:^{
        
        fromView.layer.transform = CATransform3DMakeScale(0.98,0.98,1);
        toView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished){
        
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
        }
        fromView.layer.transform = CATransform3DIdentity;
    }];
}


@end
