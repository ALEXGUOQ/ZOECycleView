//
//  ViewController.m
//  NewTestViewMy
//
//  Created by 疯兔 on 15/5/11.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"
@interface ViewController ()
- (IBAction)testS:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testS:(id)sender {
    UIStoryboard *sto = [UIStoryboard storyboardWithName:@"Test" bundle:nil];
    NewViewController *vc = sto.instantiateInitialViewController;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
@end
