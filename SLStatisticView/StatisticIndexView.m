//
//  StatisticIndexView.m
//  calendar
//
//  Created by smart on 2016/10/20.
//  Copyright © 2016年 Hadlinks. All rights reserved.
//

#import "StatisticIndexView.h"
#import <Masonry/Masonry.h>

@interface StatisticIndexView()
@property (nonatomic, weak) UILabel* indexLabel;
@end

@implementation StatisticIndexView
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) setup{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor whiteColor];
    self.indexLabel = label;
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statistics_data_bg"]];
    [self addSubview:imageView];
    [self addSubview:label];
    
    UIView* superView = self;
    //设置约束
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superView);
    }];
    
    //设置图片的约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label).with.insets(UIEdgeInsetsMake(-2,-2,-5,-2));
    }];
}

-(void)setValue:(NSString *)value{
    _value = value;
    self.indexLabel.text = value;
    [self setNeedsLayout];
}



@end
