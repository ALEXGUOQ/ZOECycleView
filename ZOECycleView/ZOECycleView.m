//
//  ZOEColletionView.m
//  ZOECycleView
//
//  Created by 疯兔 on 15/5/10.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "ZOECycleView.h"
#import "ZOECollectionViewCell.h"

@interface ZOECycleView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *mainView;
@property (nonatomic,strong)ZOECollectionViewCell *cell;
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;

@property (nonatomic,copy)selectItem didSelectCell;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)CADisplayLink *link;
@end

static NSString *const CellId = @"CycleCell";
@implementation ZOECycleView

+(instancetype)ZOECycleViewWithFrame:(CGRect)rect andImages:(NSArray *)images cycleTimes:(NSInteger)times selectAtCell:(selectItem)callBack
{
    ZOECycleView *view = [[self alloc]initWithFrame:rect];
    view.imageGroup = images;
    view.timer = times;
    view.didSelectCell = callBack;
    return view;
}
-(void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.mainView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.mainView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self setCurrentIndex:0];
}
-(void)didSelectCell:(selectItem)block
{
    if (block) {
        self.didSelectCell = block;
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageGroup.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    NSInteger index = (self.currentIndex + indexPath.item - 1 + self.imageGroup.count) % self.imageGroup.count;
    [self.cell setImage:self.imageGroup[index]];
    [self.cell setTag:index];
    if (_titleGroup.count == _imageGroup.count) {
        [self.cell setTitle:self.titleGroup[index]];
        [self.cell setTitleColor:_titleColor];
        [self.cell setTitleTextColor:_titleTextColor];
    }else if (_titleGroup){
        NSAssert(_titleGroup == nil, @"titleGroup cout must == imageGroup cout");
    }
    return self.cell;
}
#pragma mark - UIScrollViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    int page = collectionView.contentOffset.x / collectionView.bounds.size.width;
    self.currentIndex = (self.currentIndex + page - 1 + self.imageGroup.count) % self.imageGroup.count;
    NSIndexPath *myindexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.mainView scrollToItemAtIndexPath:myindexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectCell) {
        self.didSelectCell(_currentIndex);
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.link setPaused:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.link isPaused]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timer/30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.link setPaused:NO];
        });
    }
}
-(void)nextImage
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    [self.mainView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}
-(void)setTimer:(NSInteger)timer
{
    _timer = timer * 60;
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextImage)];
    [self.link setFrameInterval:_timer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timer/60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    });
}
#pragma mark - lazy
-(UICollectionView *)mainView
{
    if (_mainView == nil) {
        _mainView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
        [_mainView  registerClass:[ZOECollectionViewCell class] forCellWithReuseIdentifier:CellId];
        [_mainView setDataSource:self];
        [_mainView setDelegate:self];
        [_mainView setPagingEnabled:YES];
        [_mainView setShowsHorizontalScrollIndicator:NO];
        [_mainView setShowsVerticalScrollIndicator:NO];
        [self.layout setMinimumInteritemSpacing:0];
        [self.layout setMinimumLineSpacing:0];
        [self.layout setItemSize:self.bounds.size];
        [self.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _mainView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _layout;
}
#pragma mark - clear
-(void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow == NULL) {
        [self.link invalidate];
    }
}
//-(void)dealloc
//{
//    NSLog(@"%s",__FUNCTION__);
//}
@end
