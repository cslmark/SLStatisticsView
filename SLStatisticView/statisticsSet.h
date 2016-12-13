//
//  statisticsSet.h
//  IOS统计图标
//
//  Created by smart on 16/1/5.
//  Copyright © 2016年 smart. All rights reserved.
//
//由于该对象的属性较多，所以为该对象实现NScopying协议

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface statisticsSet : NSObject<NSCopying,NSMutableCopying>
//y轴的总数目
@property (nonatomic, assign) CGFloat ytotal;
//y轴的其实坐标
@property (nonatomic, assign) CGFloat ybasic;
//y轴的单位“1”
@property (nonatomic, assign) CGFloat yunit;
//x轴的单位"1"
@property (nonatomic, assign) CGFloat xunit;
//x轴的典型字符 - 传入参数为最大的字符串
@property (nonatomic, copy) NSString* typicalXlabel;
//y轴的典型字符 - 传入参数为最大的字符串
@property (nonatomic, copy) NSString* typicalYlabel;
//x轴的label的最小的间隔
@property (nonatomic, assign) CGFloat xaxisminstep;
//y轴顶部的间距
@property (nonatomic, assign) CGFloat yaxisTop;
//y轴底部的间距<用于放置xlabel>
@property (nonatomic, assign) CGFloat yaxisbottom;
//x轴到底部的间距
@property (nonatomic, assign) CGFloat xaxisbottom;
//视图的宽度和高度 滚动的宽度设定
@property (nonatomic, assign) CGFloat myW;
@property (nonatomic, assign) CGFloat myH;
@property (nonatomic, assign) CGFloat mysrcW;
//新增属性<折线还是曲线> == 只针对折线图
@property (nonatomic, assign) BOOL    cureved;
//是否执行动画
@property (nonatomic, assign) BOOL    animate;

/**
 *  色调和字体
 */
@property (nonatomic, strong) UIColor* ylineCorlor;
@property (nonatomic, strong) UIColor* XlabelColor;
@property (nonatomic, strong) UIColor* CurveColor;
@property (nonatomic, strong) UIColor* ReminderColor;
@property (nonatomic, strong) UIColor* PointColor;
@property (nonatomic, strong) UIFont*  XlabelFont;
@property (nonatomic, strong) UIFont*  ReminderFont;
@property (nonatomic, strong) UIFont*  YlabelFont;
@property (nonatomic, strong) UIColor* YlabelColor;
@end
