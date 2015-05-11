//
//  ZOEColletionView.m
//  ZOECycleView
//
//  Created by 疯兔 on 15/5/10.
//  Copyright (c) 2015年 Mr.z. All rights reserved.
//

#import "ZOECycleView.h"
#import "ZOECollectionViewCell.h"
#import "NSString+SandboxPath.h"

@interface ZOECycleView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *mainView;
@property (nonatomic,strong)ZOECollectionViewCell *cell;
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;

@property (nonatomic,copy)selectItem didSelectCell;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)CADisplayLink *link;
@property (nonatomic,strong)NSCache *imageCache;
@property (nonatomic,strong)NSCache *urlCache;
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
    NSAssert(self.imageGroup[0] != nil, @"imageGroup content mistake");
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
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    NSInteger index = (self.currentIndex + indexPath.item - 1 + self.imageGroup.count) % self.imageGroup.count;
    NSString *key = [NSString stringWithFormat:@"image- %tu",index];
    [self.cell setImage:[self.imageCache objectForKey:key]];
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
#pragma mark - AutoCycle
-(void)nextImage
{
    NSInteger direction;
    switch (self.scrollDirection) {
        case CycleScrollDirectionLeft:
            direction = 0;
            break;
        default:
            direction = 2;
            break;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:direction inSection:0];
    [self.mainView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}
-(void)setTimer:(NSInteger)timer
{
    _timer = timer * 60;
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextImage)];
    [self.link setFrameInterval:_timer];
}

#pragma mark - image
-(UIImage *)imageFromObject:(id)object
{
    if ([object isKindOfClass:[UIImage class]]) {
        return object;
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [self imageFromString:object];
    }
    return [self imageFromURL:object];
}
-(UIImage *)imageFromString:(NSString *)string
{
    if ([string containsString:@"//"]) {
        NSURL *url = [NSURL URLWithString:string];
        return [self imageFromURL:url];
    }
    if ([string containsString:@"/"]) {
        return [UIImage imageWithContentsOfFile:string];
    }
    return [UIImage imageNamed:string];
}
-(UIImage *)imageFromURL:(NSURL *)url
{
    __block UIImage *returnImage = [UIImage imageWithContentsOfFile:url.absoluteString.appendCacheDir];
    if (returnImage != nil) {
        return returnImage;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"noImage" ofType:@"jpg"];
    returnImage = [UIImage imageWithContentsOfFile:path];
    if ([self.urlCache objectForKey:url.absoluteString] == nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
        [self.urlCache setObject:url forKey:url.absoluteString];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                returnImage = [UIImage imageWithData:data];
                [data writeToFile:url.absoluteString.appendCacheDir atomically:YES];
            }];
        }];
    }
    return returnImage;
}

#pragma mark - lazy
-(NSArray *)imageGroup
{
    for (int i = 0; i < _imageGroup.count; i++) {
        [self.imageCache setObject:[self imageFromObject:_imageGroup[i]] forKey:[NSString stringWithFormat:@"image- %tu",i]];
    }
    return _imageGroup;
}
-(NSCache *)imageCache
{
    if (_imageCache == nil) {
        _imageCache = [[NSCache alloc]init];
    }
    return _imageCache;
}
-(NSCache *)urlCache
{
    if (_urlCache == nil) {
        _urlCache = [[NSCache alloc]init];
    }
    return _urlCache;
}
-(CycleScrollDirection)scrollDirection
{
    if (_scrollDirection != CycleScrollDirectionLeft && _scrollDirection != CycleScrollDirectionRight) {
        _scrollDirection = CycleScrollDirectionRight;
    }
    return _scrollDirection;
}

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
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timer/30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
    }
}
//-(void)dealloc
//{
//    NSLog(@"%s",__FUNCTION__);
//}
@end
