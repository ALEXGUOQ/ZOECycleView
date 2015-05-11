//
//  NewViewController.m
//  NewTestViewMy
//
//  Created by 疯兔 on 15/5/11.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "NewViewController.h"
#import "ZOECycleView.h"
@interface NewViewController ()
- (IBAction)test:(id)sender;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blueColor]];
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
    
}


-(void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
- (IBAction)test:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
