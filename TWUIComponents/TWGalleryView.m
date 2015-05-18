//
//  TWUIComponents
//

#import "TWGalleryView.h"
#import <KZAsserts.h>
#import <TWCommonLib.h>
#import "TWGalleryPageControlLayoutHelper.h"


const CGFloat kPageControlBottomOffset = 5.0f;


@interface TWGalleryView () <UIScrollViewDelegate>

@property (strong, nonatomic) TWScrollViewDelegate *scrollViewDelegate;
@property (strong, nonatomic) NSArray *contentImageViews;
@property (strong, nonatomic) UIPageControl *pageControl;

@end


@implementation TWGalleryView

#pragma mark - View initialization

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupView];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setupView];
  }
  return self;
}

- (void)setupView
{
  [self setupScrollViewDelegate];
  [self setupScrollViewProperties];
  [self setupPageControl];
}

- (void)setupScrollViewDelegate
{
  defineWeakSelf();
  self.scrollViewDelegate = [[TWScrollViewDelegate alloc] initAttachingToScrollView:self];
  self.scrollViewDelegate.didEndDeceleratingBlock = ^() {
    NSInteger index = [weakSelf currentIndex];
    CallBlock(weakSelf.galleryDidScrollToIndexBlock, index);
    weakSelf.pageControl.currentPage = index;
  };
}

- (void)setupScrollViewProperties
{
  self.pagingEnabled = YES;
  self.scrollEnabled = YES;
  self.showsHorizontalScrollIndicator = NO;
  self.showsVerticalScrollIndicator = NO;
}

- (void)setupPageControl
{
  self.pageControl = [[UIPageControl alloc] init];
  
  [self.superview addSubview:self.pageControl];
  [[TWGalleryPageControlLayoutHelper new] installConstraintsOnPageControl:self.pageControl forScrollView:self withBottomOffset:kPageControlBottomOffset];
  
  self.pageControl.hidesForSinglePage = YES;
  self.pageControl.userInteractionEnabled = NO;
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  [self setupPageControl];
}

#pragma mark - ImageView subviews handling

- (void)setImages:(NSArray *)images
{
  if (images != _images) {
    [self removeAllScrollViewImageViewSubviews];
    _images = images;
    
    NSInteger numberOfElements = images.count;
    [self updateScrollViewContentSizeForNumberOfElements:numberOfElements];
    self.pageControl.numberOfPages = numberOfElements;
    [self addImagesToScrollView:images];
  }
}

- (void)removeAllScrollViewImageViewSubviews
{
  [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
    if ([subview isKindOfClass:[UIImageView class]]) {
      [subview removeFromSuperview];
    }
  }];
}

- (void)addImagesToScrollView:(NSArray *)images
{
  NSMutableArray *mutableContentImageViews = [[NSMutableArray alloc] initWithCapacity:images.count];
  
  [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger index, BOOL *stop) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = [self imageViewContentModeForGalleryImage:image];
    [self addSubview:imageView];
    [mutableContentImageViews addObject:imageView];
  }];
  
  self.contentImageViews = [mutableContentImageViews copy];
  [self updateContentImageViewFrames];
  [self bringSubviewToFront:self.pageControl];
}

#pragma mark - View layout

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self updateScrollViewContentSizeForNumberOfElements:self.images.count];
  
  if ([self scrollViewHasAnyImageViewSubviews]) {
    [self updateContentImageViewFrames];
  }
  else {
    [self addImagesToScrollView:self.images];
  }
}

- (void)updateContentImageViewFrames
{
  [self.contentImageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
    CGRect frame = self.bounds;
    frame.origin.x = frame.size.width * idx;
    imageView.frame = frame;
  }];
}

- (void)updateScrollViewContentSizeForNumberOfElements:(NSInteger)numberOfElements
{
  CGSize contentSize = self.bounds.size;
  contentSize.width *= numberOfElements;
  self.contentSize = contentSize;
}

#pragma mark - Auxiliary methods

- (BOOL)imageFitsInGalleryScrollView:(UIImage *)image
{
  BOOL widthFits = (image.size.width <= self.bounds.size.width);
  BOOL heightFits = (image.size.height <= self.bounds.size.height);
  return (widthFits && heightFits);
}

- (UIViewContentMode)imageViewContentModeForGalleryImage:(UIImage *)image
{
  if ([self imageFitsInGalleryScrollView:image]) {
    return UIViewContentModeCenter;
  }
  return UIViewContentModeScaleAspectFit;
}

- (BOOL)scrollViewHasAnyImageViewSubviews
{
  return (self.contentImageViews.count > 0);
}

- (NSInteger)currentIndex
{
  return (self.contentOffset.x / self.bounds.size.width);
}

@end
