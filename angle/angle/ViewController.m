//
//  ViewController.m
//  angle
//
//  Created by 张 on 2018/4/20.
//  Copyright © 2018年 张. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#define DEGREES_TO_RADIANS(angle) ( M_PI / 180 * (angle))

@interface ViewController ()<CLLocationManagerDelegate>
/**
 *  定位管理者
 */
@property (nonatomic ,strong) CLLocationManager *mgr;

@property (nonatomic, strong) UIImageView *compasspointer;

@property (nonatomic, assign) float f;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:self.compasspointer];
   //  获取地理位置坐标的代码就不贴了,我在大连中山广场, 这是我的坐标 121.650592,38.927431
    float lat1 = 38.927431;
    float lng1 = 121.650592;
   // 这是北京往下一点 116.650592,38.927431
    float lat2 = 38.927431;
    float lng2 = 116.650592;
    
    
    //计算角度
    double s = [self getBearingWithLat1:lat1 whitLng1:lng1 whitLat2:lat2 whitLng2:lng2];
    double fabs(double s);
    s =fabs( s);
    if(lat2 < lat1){
        s = 180-s;
    }
    self.f =  DEGREES_TO_RADIANS(s);
    if (lng2 < lng1) {
        _f = (M_PI*2 - _f);
    }
    // 2.成为CoreLocation管理者的代理监听获取到的位置
    self.mgr.delegate = self;
    
    // 3.开始获取用户位置
    // 注意:获取用户的方向信息是不需要用户授权的
    [self.mgr startUpdatingHeading];
}


// 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /*
     magneticHeading 设备与磁北的相对角度
     trueHeading 设置与真北的相对角度, 必须和定位一起使用, iOS需要设置的位置来计算真北
     真北始终指向地理北极点
     */
    // 1.将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;
    // 2.旋转图片
    /*
     顺时针 正
     逆时针 负数
     */
    CGFloat a = 0;
    a = angle - _f;
    // 因为如果没有动画的话旋转的时候回出现卡顿的现象，为了更流畅，我们给它加个动画
    [UIView animateWithDuration:0.1 animations:^{
        // 旋转图片
        self.compasspointer.transform = CGAffineTransformMakeRotation(-a);
    }];
    
    
}


//两个经纬度之间的角度
-(double)getBearingWithLat1:(double)lat1 whitLng1:(double)lng1 whitLat2:(double)lat2 whitLng2:(double)lng2{
    
    double d = 0;
    double radLat1 =  [self radian:lat1];
    double radLat2 =  [self radian:lat2];
    double radLng1 = [self radian:lng1];
    double radLng2 =  [self radian:lng2];
    d = sin(radLat1)*sin(radLat2)+cos(radLat1)*cos(radLat2)*cos(radLng2-radLng1);
    d = sqrt(1-d*d);
    d = cos(radLat2)*sin(radLng2-radLng1)/d;
    d = [self angle:asin(d)];
    return d;
}
-(double)radian:(double)d{
    
    return d * M_PI/180.0;
}
-(double)angle:(double)r{
    
    return r * 180/M_PI;
}



#pragma mark - 懒加载
- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

-(UIImageView *)compasspointer
{
    if (!_compasspointer) {
        _compasspointer= [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"compass"]];
        _compasspointer.frame = CGRectMake(0, 0, 200, 200);
        _compasspointer.center = CGPointMake(self.view.center.x, self.view.center.y);
    }
    return _compasspointer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
