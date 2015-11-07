//
//  GPTabbar.h
//  01-GPTabbar
//
//  Created by gaozy on 15/3/22.
//  Copyright (c) 2015年 gaozy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPTabbar;
@protocol GPTabbarDelegate <NSObject>

- (void)tabbarSelected:(GPTabbar *)tabbar atIndex:(NSInteger)index item:(UIButton *)btn;

@end

@interface GPTabbar : UIView

@property (nonatomic,strong) NSArray *buttonItems;
@property (nonatomic,weak) id<GPTabbarDelegate> delegate;
//@property (nonatomic,readonly,weak) UIButton *selectedButton;
@property (nonatomic,assign) NSInteger  selectIndex;

+ (instancetype)tabbar;

- (void)setSelectedButtonAtIndex:(NSInteger) index;

@end
