//
//  ColumnChartView.h
//  IOS统计图标
//
//  Created by smart on 16/1/6.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "statisticsSet.h"

@interface ColumnChartView : UIScrollView
@property (nonatomic, assign) NSMutableArray* xarray;
@property (nonatomic, assign) NSMutableArray* yarray;
@property (nonatomic, strong) statisticsSet* linechatset;

-(void) refreashGraph;
-(void)setDataXarray:(NSMutableArray *) xarray Yarray:(NSMutableArray *) yarray;
+(instancetype) builtNewstatisticViewWithFrame:(CGRect) rect statisticset:(statisticsSet *) set;

- (void)animate;
@end
