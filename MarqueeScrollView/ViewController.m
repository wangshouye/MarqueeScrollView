//
//  ViewController.m
//  MarqueeScrollView
//
//  Created by Mr.Wang on 16/3/25.
//  Copyright © 2016年 Mr.Wang. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView              *scrollView;
@property (nonatomic, strong) UIPageControl             *pageCtrl;

@property (nonatomic, strong) UIImageView               *imageView1;
@property (nonatomic, strong) UIImageView               *imageView2;
@property (nonatomic, strong) UIImageView               *imageView3;

@property (nonatomic, assign) NSUInteger                nCurrentPage;

@property (nonatomic, strong) NSTimer                   *timer;

@property (nonatomic, strong) NSArray                   *lists;


@end

@implementation ViewController

@synthesize scrollView;
@synthesize pageCtrl;

@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;

@synthesize nCurrentPage;

@synthesize timer;
@synthesize lists;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    
    [self initScrollView];
    [self layoutScrollView];
    
    [self initPageControlView];
    [self reloadPageControlView];
    
    //定时器开始
    self.timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timerMarqueeImageView) userInfo:nil repeats:YES];
    
    [self timerMarqueeImageView];
}

- (void) initData
{
    self.lists = @[
                   [UIColor redColor],
                   [UIColor yellowColor],
                   [UIColor blackColor],
                   [UIColor blueColor],
                   [UIColor orangeColor],
                   [UIColor grayColor],
                   [UIColor greenColor],
                   [UIColor purpleColor]
                   ];
    
    nCurrentPage = 0;
}

- (void) initScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4)];
    
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
}

- (void) layoutScrollView
{
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4)];
    [scrollView addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(1 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4)];
    [scrollView addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4)];
    [scrollView addSubview:imageView3];
    
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, SCREEN_WIDTH * 0.4)];
    
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 0.4 - 20, SCREEN_WIDTH, 20)];
    [self.view addSubview:pageCtrl];
}

- (void) initPageControlView
{
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 0.4 - 20, SCREEN_WIDTH, 20)];
    
    self.pageCtrl.pageIndicatorTintColor = [UIColor redColor];
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.view addSubview:pageCtrl];
}

- (void) reloadPageControlView
{
    self.pageCtrl.numberOfPages = lists.count;
    self.pageCtrl.currentPage = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [self calculateScrollViewBigPicIndex];
    
    aScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0.0);
}

- (void)calculateScrollViewBigPicIndex
{
    CGPoint contentOffset = [scrollView contentOffset];
    
    if (contentOffset.x > SCREEN_WIDTH ) { //向左滑动
        nCurrentPage = (nCurrentPage + 1) % lists.count;
        
    } else if (contentOffset.x < SCREEN_WIDTH) { //向右滑动
        
        nCurrentPage = (nCurrentPage - 1 + lists.count) % lists.count;
    }
    
    [self setImageByCurrentIndex:nCurrentPage];
}

- (void)setImageByCurrentIndex:(NSUInteger)index
{
    if ( index < lists.count) {
        
        imageView2.backgroundColor = lists[index];
        
    } else {
        imageView2.backgroundColor = nil;
    }
    
    NSUInteger beforeIndex = ((index - 1 + lists.count) % lists.count);
    if ( beforeIndex < lists.count) {
        
        imageView1.backgroundColor = lists[beforeIndex];
    } else {
        imageView1.backgroundColor =nil;
    }
    
    NSUInteger afterIndex = ((index + 1 + lists.count) % lists.count);
    if ( afterIndex < lists.count) {
        
        imageView3.backgroundColor = lists[afterIndex];
        
    } else {
        imageView3.backgroundColor = nil;
    }
    
    pageCtrl.currentPage = index;
}

- (void) timerMarqueeImageView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    [scrollView setContentOffset:CGPointMake(offsetX + SCREEN_WIDTH, 0.0) animated:YES];
    
    // 通过 setContentOffset 这个滑动，函数scrollViewDidEndDecelerating是不执行的。所以滑动动画结束后调用一下
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:scrollView afterDelay:0.4];
}

//定时器暂停
- (void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
    [timer setFireDate:[NSDate distantFuture]];
}

//定时器继续
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    [timer setFireDate: [NSDate dateWithTimeIntervalSinceNow:6]];
}

- (void) dealloc
{
    [timer invalidate];
    self.timer = nil;
}


@end















