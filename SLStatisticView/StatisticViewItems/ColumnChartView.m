//
//  ColumnChartView.m
//  IOS统计图标
//
//  Created by smart on 16/1/6.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "ColumnChartView.h"
#import "ColumnChartBasicView.h"

@interface ColumnChartView()<ColumnChartBasicViewDelegate>
{
    CGFloat xstepdefault;
    CGFloat myW;
    CGFloat myH;
}
@property (nonatomic, weak) ColumnChartBasicView* mystatisticsView;
@end

@implementation ColumnChartView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = NO;
}

//提供一个创建该对象的类方法
+(instancetype) builtNewstatisticViewWithFrame:(CGRect) rect statisticset:(statisticsSet *) set{
    ColumnChartView *newscr = [[self alloc]initWithFrame:rect];
    ColumnChartBasicView *staview = [ColumnChartBasicView buitStatisticsWithstatisticsSet:set];
    set.myW = rect.size.width;
    set.myH = rect.size.height;
    staview.backgroundColor = [UIColor clearColor];
    staview.delegate = newscr;
    staview.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    newscr.mystatisticsView = staview;
    [newscr addSubview:staview];
    return newscr;
}

/**
 *  x轴和Y轴的数组要设备必须同时设置
 *
 *  @param xarray
 *  @param yarray
 */
-(void)setDataXarray:(NSMutableArray *) xarray Yarray:(NSMutableArray *) yarray{
    if ((xarray.count == 0) || (yarray.count == 0) || (xarray.count != yarray.count) ) {
        //传入的数据不合法
        return;
    }
    myW = self.mystatisticsView.linechatset.myW;
    myH = self.mystatisticsView.linechatset.myH;
    
    self.mystatisticsView.xarray = xarray;
    self.mystatisticsView.yarray = yarray;
    
    xstepdefault = self.mystatisticsView.linechatset.xaxisminstep;
    //默认的宽度   xstep   xleft  xright
    CGFloat staW = xarray.count * xstepdefault + 20 + 20;
    if (staW < myW) {
        staW = myW;
    }
    self.mystatisticsView.frame = CGRectMake(0, 0, staW, myH);
    self.contentSize = CGSizeMake(staW, myH);
    
    [self.mystatisticsView setNeedsDisplay];
}

//仅仅是数组发生改变的时候刷新数值
-(void) refreashGraph{
    [self.mystatisticsView setNeedsDisplay];
}

#pragma mark - 重写set方法
-(void) setLinechatset:(statisticsSet *)linechatset{
    _linechatset = linechatset;
    [self.mystatisticsView setLinechatset:linechatset];
}

#pragma mark - 统计部分的代理
-(void)ColumnChartBasicView:(ColumnChartBasicView *)view width:(CGFloat) width Scroll:(CGFloat)scr{
    //位置调整
    self.mystatisticsView.frame = CGRectMake(0, 0, self.mystatisticsView.frame.size.width, self.mystatisticsView.frame.size.height);
    
    CGFloat newwidth = width;
    //其中20+20 以BasicView视图中的left对应
    CGFloat staW = self.xarray.count * xstepdefault + 20 + 20;
    if (width < staW) {
        newwidth = staW;
    }
    self.contentSize = CGSizeMake(newwidth, myH);
    if (width > myW) {
        self.contentOffset = CGPointMake(scr-myW*0.5, 0);
    }
    [self.mystatisticsView setNeedsDisplay];
}

#pragma mark - 增加动画部分
- (void)animate{
    [self.mystatisticsView animate];
}



@end
