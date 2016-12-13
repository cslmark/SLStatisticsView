//
//  SLLineChatView.h
//  SLStatisticGraph
//
//  Created by smart on 2016/11/7.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLLineChartView.h"
#import "LineChartView.h"
#import "statisticsSet.h"
#import "LinechartBasicView.h"


@interface SLLineChartView : UIView
@property (nonatomic, strong) statisticsSet* linechatset;

+(instancetype) builtNewstatisticViewWithFrame:(CGRect) rect statisticset:(statisticsSet *) set;
-(void)setDataXarray:(NSMutableArray *) xarray Yarray:(NSMutableArray *) yarray;
- (void)animate;
@end
