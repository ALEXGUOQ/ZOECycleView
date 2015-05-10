//
//  ZOECollectionViewCell.h
//  ZOECycleView
//
//  Created by 疯兔 on 15/5/11.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZOECollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *titleTextColor;
@end
