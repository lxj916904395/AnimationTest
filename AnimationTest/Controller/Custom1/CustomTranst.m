//
//  CustomTranst.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/11.
//

#import "CustomTranst.h"

#import "Customtrans1ViewController.h"
#import "Customtrans2ViewController.h"
@interface CustomTranst()<CAAnimationDelegate>
{
    id <UIViewControllerContextTransitioning> _transitionContext;
}

@end
@implementation CustomTranst

//转场动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return .8f;
}

//自定义转场动画实现
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    _transitionContext = transitionContext;
    
    //获取容器（理解为 navigationController.view）
    UIView *containerView = [transitionContext containerView];
    
    //转场动画的两个参与VC
    Customtrans1ViewController *VC1;
    Customtrans2ViewController *VC2;
    
    //动画开始点
    CGPoint point;

    if (_isPush) {
        VC1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        VC2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        point = VC1.clickPoint;
    }else{
        VC2 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        VC1 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        point = VC2.clickPoint;
    }
    
    
    [containerView addSubview:VC1.view];
    [containerView addSubview:VC2.view];
    

    //构造以点击处为中心的小圆
    CGRect rect = CGRectMake(point.x-5, point.y-5, 10, 10);
    
    //小圆
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    
    //获取动画中心点
    CGPoint centP = point;
    
    CGFloat halfWidth = CGRectGetWidth(VC2.view.frame)/2;
    CGFloat halfHeight = CGRectGetHeight(VC2.view.frame)/2;
    
    //获取动画大圆半径
    CGFloat radius;
    
    if (CGRectContainsPoint(CGRectMake(halfWidth, 0, halfWidth, halfHeight), centP)) {
         //第一象限
        radius = sqrtf(centP.x*centP.x+(2*halfHeight-centP.y)*(2*halfHeight-centP.y));
    }else if (CGRectContainsPoint(CGRectMake(0, 0, halfWidth, halfHeight),point)){
         //第二象限
        radius = sqrtf((2*halfWidth-centP.x)*(2*halfWidth-centP.x)+(2*halfHeight-centP.y)*(2*halfHeight-centP.y));

    }else if (CGRectContainsPoint(CGRectMake(0, halfHeight, halfWidth, halfHeight), centP)){
        //第三象限
        radius = sqrtf((2*halfWidth-centP.x)*(2*halfWidth-centP.x)+centP.y*centP.y);
    }else{
        //第四象限
        radius = sqrtf(centP.x*centP.x+centP.y*centP.y);
    }
    
    /**
     所需大圆路径
     ArcCenter:中心点
     radius：半径
     startAngle：开始角度
     endAngle：结束角度
     clockwise：顺时针或逆时针
     */
    UIBezierPath *bigPath = [UIBezierPath bezierPathWithArcCenter:centP radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    //路径添加在layer上
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    if (_isPush) {
        shapeLayer.path = bigPath.CGPath;
    }else{
        
        shapeLayer.path = smallPath.CGPath;
    }
    
    //添加蒙版
    VC2.view.layer.mask = shapeLayer;

    //添加动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.fromValue = (_isPush?(id)smallPath.CGPath:(id)bigPath.CGPath);
    anim.keyPath = @"path";
    anim.delegate = self;
    [shapeLayer addAnimation:anim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //完成转场动画
    [_transitionContext completeTransition:YES];

    UIViewController *VC;
    if (_isPush) {
        VC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }else{
        VC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    
   //取消蒙版
    VC.view.layer.mask = nil;
}
@end
