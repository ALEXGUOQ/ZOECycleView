# ZOECycleView
###How To Use/如何使用
#####import "ZOECycleView.h"
####+method
````
 +(instancetype)ZOECycleViewWithFrame:(CGRect)rect andImages:(NSArray *)images cycleTimes:(NSInteger)times selectAtCell:(selectItem)callBack;
````

####-method
````
    ZOECycleView *view = [[ZOECycleView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [view setImageGroup:arrayM];
    [view setTimer:2];
    [view setTitleGroup:arrayT];
    [view didSelectCell:^(NSInteger selectNumber) {
        NSLog(@"%tu",selectNumber);
    }];
    [view setTitleColor:[UIColor redColor]];
    [view setTitleTextColor:[UIColor yellowColor]];
    [self.view addSubview:view];
````
#####warning/注意
- if use TitleGroup
- TitleGroup count == ImageGroup
- if you need to modify the Label, please go to the "ZOECollectionViewCell.h"
- ImageGroup.count >= 3
- 如果使用了标题数组，则标题数组的大小必须与图片数组大小一致，并且图片数组不可以小于3
- 如果需要修改Label，请前往“ZOECollectionViewCell.h”
- z.o.e@outlook.com