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


####5.11更新－全新设计的imageGroup，支持多种NSString/URL/UIImage混合投入,新增scrollDirection属性控制滚动方向，针对URL设计了沙盒存储机制以及全类型图片缓存机制，内置了专供下载缓慢的noImage.jpg，便捷更换自定义占位图片，经过了大量的内存测试
````
    NSMutableArray *arrayM = [NSMutableArray array];
    NSString *name = [NSString stringWithFormat:@"01"];
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"jpg" inDirectory:@"images"];
    [arrayM addObject:path];
    [arrayM addObject:@"http://a2.qpic.cn/psb?/V11jri623txyVG/tpLqOxzDLpZeXKkLbf0Nt0dk*Ku5VLpBk1SvEfkV9y0!/b/dLQvgm8dDAAA&bo=FAFYAQAAAAAFAG8!&rf=viewer_4"];
    NSURL *url = [NSURL URLWithString:@"http://a2.qpic.cn/psb?/V11jri623txyVG/MIxJ7H7FS.uKVuu0xT2q.FU2H1oM4MVYBEwJ8xzlfzU!/b/dG6Qem8vDAAA&bo=cAGmAQAAAAAFAPU!&rf=viewer_4"];
    [arrayM addObject:url];
    [arrayM addObject:@"02"];
    ZOECycleView *view = [[ZOECycleView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [view setImageGroup:arrayM];
    [view setTimer:2];
    [view didSelectCell:^(NSInteger selectNumber) {
        NSLog(@"%tu",selectNumber);
    }];
    [view setScrollDirection:CycleScrollDirectionLeft];
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
- 如果使用中遇到问题请邮件z.o.e@outlook.com