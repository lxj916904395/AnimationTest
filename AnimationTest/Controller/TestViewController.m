//
//  ViewController.m
//  AnimationTest
//
//  Created by zhongding on 2018/9/5.
//

#import "TestViewController.h"
#import "ViewController1.h"
#import "Customtrans1ViewController.h"
#import "CustomtransType2ViewController.h"
#import "DynamicViewController.h"
#import "TodayTopViewController.h"

#import "CustomTranstType2.h"
#import "TodayTopTransition.h"


/**
 动画创建三步骤
 1.创建动画对象
 2.设置动画属性
 3.给layer添加动画
 */

#define angleToRorate(angle) ((angle)/180.0 * M_PI)

@interface TestViewController ()<CAAnimationDelegate,UINavigationControllerDelegate>{
    NSArray*_images;
    NSInteger _index;
}
@property (weak, nonatomic) IBOutlet UIImageView *aliImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UIImageView *car2Image;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _images = @[@"view0",@"view1",@"view2"];
   
}

//基础动画
- (void)baseAnimation{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.delegate = self;
    anim.keyPath = @"position.y";
    
    //动画完成的终点位置
    anim.toValue = @400;
    anim.fromValue = @200;
    
    //动画完成是否移除
    anim.removedOnCompletion = NO;
    
    //保持最新的状态
    anim.fillMode = kCAFillModeForwards;
    
    [_aliImageView.layer addAnimation:anim forKey:nil];
}

//关键帧动画
- (void)keyframeAnim{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@angleToRorate(-6),@angleToRorate(6),@angleToRorate(-6)];
    //动画执行次数
    anim.repeatCount = HUGE_VAL;
    
    [_aliImageView.layer addAnimation:anim forKey:nil];
    
}

//小车沿着曲线移动
- (void)testAnim{
    CGPoint startPoint = CGPointMake(50, 300);
    //构造曲线
    UIBezierPath *path = [UIBezierPath new];
    //起始点
    [path moveToPoint:startPoint];
    // 终点，以及两个控制点
    [path addCurveToPoint:CGPointMake(350, 300) controlPoint1:CGPointMake(150, 200) controlPoint2:CGPointMake(200, 400)];
    
    
    //添加曲线
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = path.CGPath;
    //填充色
    shapeLayer.fillColor = nil;
    //曲线颜色
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    CALayer *car = [CALayer new];
    car.contents = (id)[UIImage imageNamed:@"car"].CGImage;
    car.frame = CGRectMake(startPoint.x-15, startPoint.y, 30, 30);
    car.anchorPoint = CGPointMake(0.5, 0.8);
    [self.view.layer addSublayer:car];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation new];
    anim.keyPath = @"position";
    //动画路径
    anim.path = path.CGPath;
    //保持最终位置
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.duration = 4;
    anim.repeatCount = 1;
    [car addAnimation:anim forKey:nil];
    
    
    //    CABasicAnimation *scaleAnim = [CABasicAnimation new];
    //    scaleAnim.keyPath = @"backgroundColor";
    //    scaleAnim.toValue = (id)[UIColor yellowColor].CGColor;
    //    scaleAnim.duration = 4;
    //    scaleAnim.removedOnCompletion = NO;
    //    scaleAnim.fillMode = kCAFillModeForwards;
    //
    //    //组动画
    //    CAAnimationGroup *group = [CAAnimationGroup new];
    //    group.animations = @[anim,scaleAnim];
    //    [car addAnimation:group forKey:nil];
}

//转场动画
- (void)transAnim{
    _imageView2.image = [UIImage imageNamed:_images[_index]];
    
    CATransition *anim = [CATransition animation];
    //动画类型
    anim.type = @"oglFlip";
    anim.subtype = kCATransitionFromLeft;
    
    //动画开始、结束位置
    //    anim.startProgress = .2;
    //    anim.endProgress = .5;
    
    
    anim.duration = 1;
    
    [_imageView2.layer addAnimation:anim forKey:nil];
    
    _index++;
    if(_index>2)_index=0;
}

- (void)springAnim{
    CASpringAnimation *anim = [CASpringAnimation animation];
    anim.toValue = @250;
    anim.keyPath = @"position.x";
    anim.mass = 5;
    anim.initialVelocity = 2;
    anim.duration = 4;
    anim.autoreverses = YES;
    //    anim.removedOnCompletion = NO;
    //    anim.fillMode  = kCAFillModeForwards;
    [_carImage.layer addAnimation:anim forKey:nil];
}

- (void)bezierAnim{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_aliImageView.center];
    
    CGPoint controlPoint = CGPointMake(_car2Image.center.x, _aliImageView.center.y);
    [path addQuadCurveToPoint:_car2Image.center controlPoint:controlPoint];
    
    path.lineWidth = 1;
    [path stroke];
    
    //添加曲线
    CAShapeLayer *pathLayer = [CAShapeLayer new];
    pathLayer.path = path.CGPath;
    //填充色
    pathLayer.fillColor = nil;
    //曲线颜色
    pathLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:pathLayer];
    
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    anim.duration = 0.8;
    anim.path = path.CGPath;
    [_aliImageView.layer addAnimation:anim forKey:nil];
    
    CAKeyframeAnimation *anim1 = [CAKeyframeAnimation animation];
    anim1.keyPath = @"transform.scale";
    anim1.values = @[@0.8,@0.3];
    anim1.duration = 0.8;
    [_aliImageView.layer addAnimation:anim1 forKey:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self keyframeAnim];
    [self testAnim];
    [self transAnim];
    [self springAnim];
    
    [self bezierAnim];
}


- (IBAction)jump:(id)sender {
    CATransition *anim = [CATransition animation];
    anim.type = kCATransitionReveal;
    anim.subtype = kCATransitionFromBottom;
    anim.duration = 1;
    [self.navigationController.view.layer  addAnimation:anim forKey:nil];
    ViewController1 *vc = [ViewController1 new];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)customerTrans:(id)sender {
    //自定义转场动画1
    Customtrans1ViewController *customer = [Customtrans1ViewController new];
    [self.navigationController pushViewController:customer animated:YES];
}


- (IBAction)customerTrans2:(id)sender {
    //自定义转场动画2
    CustomtransType2ViewController *customer = [CustomtransType2ViewController new];
    [self.navigationController pushViewController:customer animated:YES];
}



- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if ( operation == UINavigationControllerOperationPush) {
        if ([toVC isKindOfClass:CustomtransType2ViewController.class] ) {
            CustomTranstType2 *custom = [CustomTranstType2 new];
            custom.isPush = YES;
            return custom;
        }else if ([toVC isKindOfClass:TodayTopViewController.class]){
            return [TodayTopTransition new];
        }
    }
    return nil;
}

- (IBAction)dynamic:(id)sender {
    [self.navigationController pushViewController:[DynamicViewController new] animated:YES];
}

- (IBAction)todayTop:(id)sender {
    [self.navigationController pushViewController:[TodayTopViewController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
