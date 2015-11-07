//
//  GPTabbar.m
//  01-GPTabbar
//
//  Created by gaozy on 15/3/22.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import "GPTabbar.h"

#define Tabbar_Width [UIScreen mainScreen].bounds.size.width

static CGFloat const kButtonSlotHeight = 44;

@implementation GPTabbar

#pragma mark -  初始化方法
+ (instancetype)tabbar
{
//    NSLog(@"tabbar %p",self);
    return  [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        NSLog(@"initWithFrame %p",self);
    }
    return self;
}

#pragma mark - 设置button
- (void)setButtonItems:(NSArray *)buttonItems
{
    NSParameterAssert([buttonItems count] > 0);
    _buttonItems = buttonItems;
    
    CGFloat itemY =0;
    CGFloat itemW = Tabbar_Width/buttonItems.count;
    CGFloat itemH = kButtonSlotHeight;
    
    for (NSInteger index = 0; index < buttonItems.count; index++) {
        CGFloat itemX = index*itemW;
        
        UIButton *btn = buttonItems[index];
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index;
        btn.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
    }
    
}

- (void)btnClick:(UIButton *)btn
{
    [_delegate tabbarSelected:self atIndex:btn.tag item:_buttonItems[btn.tag]];
}

- (void)setSelectedButtonAtIndex:(NSInteger)index
{
    [self btnClick:self.buttonItems[index]];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    UIButton *btn = self.buttonItems[selectIndex];
    [self.buttonItems enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = (self.buttonItems[idx] == btn);
        UIColor *bgColor = button.selected ? [UIColor colorWithRed:1 green:0.4f blue:0.8f alpha:1] : [UIColor clearColor];
        [button setBackgroundColor:bgColor];
        button.titleLabel.font =  button.selected ?[UIFont systemFontOfSize:20] :[UIFont systemFontOfSize:17];
    }];
}


@end
