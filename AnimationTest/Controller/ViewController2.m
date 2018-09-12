//
//  ViewController2.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/7.
//

#import "ViewController2.h"
#import "MenuView.h"

#import <YYKit.h>

@interface ViewController2 (){
    UIView *view1;
    UIView *view2;
    
    CGRect oldView1Frame;
    CGPoint oldViewCenter;
    CGFloat oldR1;
    CGFloat r1;
    
    CAShapeLayer *shapeLayer;
}
@property(strong ,nonatomic) MenuView *menuView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initUI];
}

- (void)_initUI{
      _menuView = [[MenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(30, 600, 40, 40)];
    view1.backgroundColor = [UIColor redColor];
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 20;
    [self.view addSubview:view1];
    
    view2 = [[UIView alloc] initWithFrame:view1.frame];
    view2.backgroundColor = [UIColor redColor];
    view2.layer.masksToBounds = YES;
    view2.layer.cornerRadius = 20;
    [self.view addSubview:view2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view2.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"99";
    [view2 addSubview:label];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [view2 addGestureRecognizer:pan];
    
    oldView1Frame = view1.frame;
    oldViewCenter = view1.center;
    oldR1 = CGRectGetWidth(oldView1Frame)/2;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor redColor].CGColor;
}

#pragma mark ***************** 拖拽手势;
- (void)tap:(UITapGestureRecognizer*)ges{
    if (ges.state == UIGestureRecognizerStateChanged) {
        //view2的中心点随手势移动
        view2.center = [ges locationInView:self.view];
        
        if (r1<10) {
            view1.hidden = YES;
            [shapeLayer removeFromSuperlayer];
        }else{
            [self keyPath];
        }

    }else if (ges.state == UIGestureRecognizerStateCancelled ||
              ges.state == UIGestureRecognizerStateFailed ||
              ges.state == UIGestureRecognizerStateEnded){
        //手势结束、取消
        [shapeLayer removeFromSuperlayer];
        view1.hidden = YES;

        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->view2.center = self->oldViewCenter;
        } completion:^(BOOL finished) {
            //恢复坐标
            view1.hidden = NO;
            r1 = oldView1Frame.size.width/2;
            view1.frame = oldView1Frame;
            view1.layer.cornerRadius = r1;
        }];
    }
}

- (void)keyPath{

    //求出两个view的中心点
    CGPoint centerP1 = view1.center;
    CGPoint centerP2 = view2.center;

    
    //计算中心点距离
    CGFloat dis = sqrtf((centerP1.x-centerP2.x)*(centerP1.x-centerP2.x)+(centerP1.y-centerP2.y)*(centerP1.y-centerP2.y));
    
    //半径
    CGFloat r2 = CGRectGetWidth(view2.frame)/2;
    r1 = CGRectGetWidth(oldView1Frame)/2 - dis/30;
    
    //计算正弦余弦
    CGFloat sin = (centerP2.x - centerP1.x) / dis;
    CGFloat cos = (centerP1.y - centerP2.y) / dis;
    
    //获取6个关键点坐标
    
    //A点坐标
    CGPoint pA = CGPointMake(centerP1.x-r1*cos, centerP1.y-r1*sin);
    
    //B点坐标
    CGPoint pB = CGPointMake(centerP1.x+r1*cos, centerP1.y+r1*sin);
    
    //C点坐标
    CGPoint pC = CGPointMake(centerP2.x+r2*cos, centerP2.y+r2*sin);
    
    //D点坐标
    CGPoint pD = CGPointMake(centerP2.x-r2*cos, centerP2.y-r2*sin);
    
    //O点坐标
    CGPoint pO = CGPointMake(pA.x+dis/2*sin+dis/20, pA.y-dis/2*cos);
    
    //P点坐标
    CGPoint pP = CGPointMake(pB.x+dis/2*sin-dis/20, pB.y-dis/2*cos);
    
    
    //根据点画贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pA];
    [path addQuadCurveToPoint:pD controlPoint:pO];
    [path addLineToPoint:pC];
    [path addQuadCurveToPoint:pB controlPoint:pP];
    [path closePath];
    
    //添加路径
    shapeLayer.path = path.CGPath;
    [self.view.layer insertSublayer:shapeLayer below:view2.layer];

    //重新设置坐标
    view1.center = oldViewCenter;
    view1.bounds = CGRectMake(0, 0, r1*2, r1*2);
    view1.layer.cornerRadius = r1;
}

- (IBAction)back:(id)sender {
    CATransition *anim = [CATransition animation];
    anim.type = @"pageUnCurl";
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)menu:(id)sender {
    if (!_menuView.superview) {
        [_menuView showInView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
