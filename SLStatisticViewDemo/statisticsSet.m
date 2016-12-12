//
//  statisticsSet.m
//  IOS统计图标
//
//  Created by smart on 16/1/5.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "statisticsSet.h"

@implementation statisticsSet
- (id)copyWithZone:(NSZone *)zone
{
    statisticsSet *copy = [[[self class] allocWithZone:zone] init];
    copy.ytotal = self.ytotal;
    copy.ybasic = self.ybasic;
    copy.yunit = self.yunit;
    copy.xunit = self.xunit;
    
    copy.typicalXlabel = [self.typicalXlabel copyWithZone:zone];
    copy.typicalYlabel = [self.typicalYlabel copyWithZone:zone];
    
    copy.xaxisminstep = self.xaxisminstep;
    copy.yaxisTop = self.yaxisTop;
    copy.yaxisbottom = self.yaxisbottom;
    copy.xaxisbottom = self.xaxisbottom;
    
    copy.myH = self.myH;
    copy.myW = self.myW;
    copy.mysrcW = self.mysrcW;
    
    copy.ylineCorlor = [self.ylineCorlor copyWithZone:zone];
    copy.XlabelColor = [self.XlabelColor copyWithZone:zone];
    copy.CurveColor = [self.CurveColor copyWithZone:zone];
    copy.ReminderColor = [self.ReminderColor copyWithZone:zone];
    copy.PointColor = [self.PointColor copyWithZone:zone];
    copy.XlabelFont = [self.XlabelFont copyWithZone:zone];
    copy.ReminderFont = [self.ReminderFont copyWithZone:zone];
    return copy;
}

@end
