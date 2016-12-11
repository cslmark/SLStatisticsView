//
//  UIBezierPath+curved.h
//  SLStatisticGraph
//
//  Created by smart on 16/4/26.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (curved)
- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;
@end
