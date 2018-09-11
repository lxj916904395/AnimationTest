//
//  CustomTranstType2.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/11.
//

#import "CustomTranstType2.h"

static UIImageView*imgView0;
static UIImageView*imgView1;

@interface CustomTranstType2()<CAAnimationDelegate>{
    id <UIViewControllerContextTransitioning> _transitionContext;
}
@end

@implementation CustomTranstType2

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    
    CGFloat screenHeight = CGRectGetHeight(fromVC.view.frame);
    CGFloat screenWidth = CGRectGetWidth(fromVC.view.frame);
    
    if(!imgView0) {
        CGRect  rect0 = CGRectMake(0 , 0 , screenWidth, screenHeight/2);
        
        UIImage *image0 = [self imageFromView:fromVC.view atFrame:rect0];
        imgView0 = [[UIImageView alloc] initWithImage:image0];
    }
    
    
    if (!imgView1) {
        CGRect  rect1 = CGRectMake(0 , screenHeight/2 , screenWidth, screenHeight/2);
        UIImage *image1 = [self imageFromView:fromVC.view atFrame:rect1];
        imgView1 = [[UIImageView alloc] initWithImage:image1];
    }
    
    [containView addSubview:fromVC.view];
    if(_isPush)[containView addSubview:toVC.view];
    
    [containView addSubview:imgView0];
    [containView addSubview:imgView1];
    
    [UIView animateWithDuration:.5 animations:^{
        if (self.isPush) {
            imgView0.layer.transform = CATransform3DMakeTranslation(0, -screenHeight/2, 0);
            imgView1.layer.transform = CATransform3DMakeTranslation(0, screenHeight, 0);
        }else{
            imgView0.layer.transform =
            imgView1.layer.transform = CATransform3DIdentity;
        }
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
        }

        if (!toVC.view.superview) {
            [containView addSubview:toVC.view];
        }
        
        [imgView0 removeFromSuperview];
        [imgView1 removeFromSuperview];
    }];
}

- (UIImage *)imageFromView: (UIView *)view atFrame:(CGRect)rect{
    
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
    
}
@end

