//
//  ZOEColletionView.h
//  ZOECycleView
//
//  Created by 疯兔 on 15/5/10.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^selectItem)(NSInteger selectNumber);
@interface ZOECycleView : UIView
@property (nonatomic,strong)NSArray *imageGroup;
@property (nonatomic,strong)NSArray *titleGroup;
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *titleTextColor;
@property (nonatomic,assign)NSInteger timer;
-(void)didSelectCell:(selectItem) block;
+(instancetype)ZOECycleViewWithFrame:(CGRect)rect andImages:(NSArray *)images cycleTimes:(NSInteger)times selectAtCell:(selectItem)callBack;
@end
