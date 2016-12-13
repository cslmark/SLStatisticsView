//
//  SLColumnChartView.h
//  calendar
//
//  Created by smart on 2016/12/13.
//  Copyright © 2016年 Hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColumnChartBasicView.h"
#import "ColumnChartView.h"
#import "statisticsSet.h"

@interface SLColumnChartView : UIView
@property (nonatomic, strong) statisticsSet* columnchatset;
+(instancetype) builtNewstatisticViewWithFrame:(CGRect) rect statisticset:(statisticsSet *) set;
-(void)setDataXarray:(NSMutableArray *) xarray Yarray:(NSMutableArray *) yarray;
- (void)animate;
@end
