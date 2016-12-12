//
//  ColumnChartBasicView.h
//  IOS统计图标
//
//  Created by smart on 16/1/5.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class statisticsSet, ColumnChartBasicView;

@protocol ColumnChartBasicViewDelegate <NSObject>
@optional
//因为手势的原因导致控件距离的改变的代理
-(void) ColumnChartBasicView:(ColumnChartBasicView*) view width:(CGFloat) width Scroll:(CGFloat) scr;
@end

@interface ColumnChartBasicView : UIControl
@property (nonatomic, assign) BOOL shouldAnimate;
@property (nonatomic, strong) statisticsSet* linechatset;
@property (nonatomic, strong) NSMutableArray* yarray;
@property (nonatomic, strong) NSMutableArray* xarray;
@property (nonatomic, weak) id<ColumnChartBasicViewDelegate> delegate;


- (void)animate;
+(ColumnChartBasicView *)buitStatisticsWithstatisticsSet:(statisticsSet*) linechatset;
@end
