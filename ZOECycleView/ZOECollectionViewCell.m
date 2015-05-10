//
//  ZOECollectionViewCell.m
//  ZOECycleView
//
//  Created by 疯兔 on 15/5/11.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "ZOECollectionViewCell.h"
@interface ZOECollectionViewCell()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;
@end
@implementation ZOECollectionViewCell
-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self addSubview:self.imageView];
}
-(void)setTitle:(NSString *)title
{
    if (title == nil) {
        return;
    }
    [self.label setText:title];
    [self addSubview:self.label];
}
-(void)setTitleColor:(UIColor *)titleColor
{
    if (titleColor == nil) {
        return;
    }
    [self.label setBackgroundColor:titleColor];
}
-(void)setTitleTextColor:(UIColor *)titleTextColor
{
    if (titleTextColor == nil) {
        return;
    }
    [self.label setTextColor:titleTextColor];
}
#pragma mark - 修改标题和字体大小
-(UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)];
        [_label setTextAlignment:NSTextAlignmentRight];
        [_label setBackgroundColor:[UIColor grayColor]];
        [_label setTextColor:[UIColor whiteColor]];
        [_label setAlpha:0.7];
    }
    return _label;
}
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _imageView;
}
@end
