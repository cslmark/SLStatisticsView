//
//  SLLineChatView.m
//  SLStatisticGraph
//
//  Created by smart on 2016/11/7.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "SLLineChartView.h"


@interface SLLineChartView()
{
    CGFloat ylabelW;
}
@property (nonatomic, weak) LineChartView *newscr;
@property (nonatomic, weak) UIView* ylabelView;
@end

@implementation SLLineChartView
//提供一个创建该对象的类方法
+(instancetype) builtNewstatisticViewWithFrame:(CGRect) rect statisticset:(statisticsSet *) set{
    SLLineChartView* slLineChatView = [[self alloc]initWithFrame:rect];
    //根据绘制的内容开始滑出Y轴
    UIView* view = [self getYAxisViewWith:rect statisticset:set];
    slLineChatView.ylabelView = view;
    [slLineChatView addSubview:view];
    CGFloat yViewW = view.frame.size.width;
    
    CGRect lineChatRect = CGRectMake(rect.origin.x+yViewW, 0, rect.size.width - yViewW, rect.size.height);
    LineChartView *newscr = [LineChartView builtNewstatisticViewWithFrame:lineChatRect statisticset:set];
    slLineChatView.newscr = newscr;
    [slLineChatView addSubview:newscr];
    return slLineChatView;
}

/**
 *  x轴和Y轴的数组要设备必须同时设置
 *
 *  @param xarray
 *  @param yarray
 */
-(void)setDataXarray:(NSMutableArray *) xarray Yarray:(NSMutableArray *) yarray{
    [self.newscr setDataXarray:xarray Yarray:yarray];
}

#pragma mark - 重写set方法
-(void) setLinechatset:(statisticsSet *)linechatset{
    _linechatset = linechatset;
    [self.ylabelView removeFromSuperview];
    UIView* view = [SLLineChartView getYAxisViewWith:self.frame statisticset:linechatset];
    self.ylabelView = view;
    [self addSubview:view];
    [self.newscr setLinechatset:linechatset];
}

//仅仅是数组发生改变的时候刷新数值
-(void) refreashGraph{
    [self.newscr refreashGraph];
}

#pragma mark - 动画部分的添加
- (void)animate{
    [self.newscr animate];
}

#pragma mark - 增加绘制Y轴的方法
+(UIView *) getYAxisViewWith:(CGRect) rect statisticset:(statisticsSet *) set{
    CGFloat myH = rect.size.height;
    CGFloat ybottom = set.yaxisbottom;
    CGFloat ytop = set.yaxisTop;
    CGFloat ypixunit = (myH - ybottom - ytop) / (set.ytotal - set.ybasic);
    CGFloat yaxisCount = (set.ytotal - set.ybasic) / set.yunit;
    
    //根据字体计算出宽度
    UIFont*  yLabelFont;
    if (set.YlabelFont == nil) {
        yLabelFont = set.YlabelFont;
    }else{
        yLabelFont = [UIFont systemFontOfSize:14.0];
    }
    CGSize maxSize = [self lineSizeWithFont:yLabelFont WithString:set.typicalYlabel];
    CGFloat yAxisunit = maxSize.height;
    CGFloat yAxisViewW = maxSize.width;
    
    UIView* yAxisView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yAxisViewW, myH)];
    yAxisView.backgroundColor = [UIColor clearColor];
    
    CGFloat lastYTop = myH;
    UIColor* ylableColor;
    if (set.YlabelColor == nil) {
        ylableColor = set.YlabelColor;
    }else{
        ylableColor = [UIColor whiteColor];
    }
    for (int i = 0; i < (yaxisCount+0.1); i++) {
        UILabel* ylabel = [[UILabel alloc] init];
        ylabel.font = yLabelFont;
        
        ylabel.textColor = ylableColor;
        ylabel.textAlignment = NSTextAlignmentRight;
        
        int currentY = (int)(set.ybasic + i*set.yunit);
        ylabel.text = [NSString stringWithFormat:@"%d", currentY];
        ylabel.bounds = CGRectMake(0, 0, yAxisViewW, yAxisunit);
        
        CGFloat Ybottom =  ybottom +  ypixunit * (i*set.yunit);
        CGFloat centerY = myH - Ybottom;
        CGFloat centerX = yAxisViewW/2;
        ylabel.center = CGPointMake(centerX, centerY);
        
        if ((lastYTop - centerY) > (yAxisunit/2.0+5)) {
            [yAxisView addSubview:ylabel];
            lastYTop = centerY;
        }else{
            
        }
    }
    return yAxisView;
}


+ (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize WithString:(NSString *) msg
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [msg boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)lineSizeWithFont:(UIFont *)font  WithString:(NSString *) msg{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [msg sizeWithAttributes:attrs];
}





@end
