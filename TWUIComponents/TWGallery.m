//
//  GalleryPlayground
//

#import "TWGallery.h"


@interface TWGallery () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *contentImageViews;

@end


@implementation TWGallery

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.scrollView.delegate = self;
  self.scrollView.pagingEnabled = YES;
  self.scrollView.scrollEnabled = YES;
  self.scrollView.showsHorizontalScrollIndicator = NO;
  self.scrollView.showsVerticalScrollIndicator = NO;
  
  NSArray *images = self.images;
  
  // 1. extend scrollView content size to 2x horizontal width
  NSInteger numberOfElements = images.count;
  [self setupScrollViewContentSizeForNumberOfElements:numberOfElements];
  
  // 2. place two images in the scroll view and allow scrolling
  // first just put them in imageViews with the size of the contentPane
//  [self addImagesToScrollView:images];
  
  // 3. adjust pageControl
  self.pageControl.hidesForSinglePage = YES;
  self.pageControl.numberOfPages = numberOfElements;
}

// zly tryb rozciagania mamy ustawiony!!
- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  if ([self scrollViewAlreadyHasImageSubviews]) {
    [self updateContentImageViewFrames];
  }
  else {
    [self addImagesToScrollView:self.images];
  }
}

- (BOOL)scrollViewAlreadyHasImageSubviews
{
  return (self.contentImageViews.count > 0);
}

- (void)addImagesToScrollView:(NSArray *)images
{
  NSMutableArray *mutableContentImageViews = [[NSMutableArray alloc] initWithCapacity:images.count];
  
  [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger index, BOOL *stop) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:imageView];
    [mutableContentImageViews addObject:imageView];
  }];
  
  self.contentImageViews = [mutableContentImageViews copy];
  [self updateContentImageViewFrames];
}

- (void)updateContentImageViewFrames
{
  [self.contentImageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = frame.size.width * idx;
    imageView.frame = frame;
  }];
}

- (void)setupScrollViewContentSizeForNumberOfElements:(NSInteger)numberOfElements
{
  CGSize contentSize = self.scrollView.bounds.size;
  contentSize.width *= numberOfElements;
  self.scrollView.contentSize = contentSize;
}

#pragma mark - TempDataSource

- (NSArray *)images
{
  NSArray *images = @[
                      [UIImage imageNamed:@"dzikMaly.jpeg"],
                      [UIImage imageNamed:@"dzikDuzy.jpg"]
                    ];
  return images;
}

#pragma mark - UIScrollViewDelegate
// TODO: extract this to a separate file!

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  NSInteger newIndex = [self currentScrollViewIndex];
  // TODO: call response block here galleryDidScrollToIndex:
  
  // TODO: change page control indicator here!!
  self.pageControl.currentPage = newIndex;
}

- (NSInteger)currentScrollViewIndex
{
  return (self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
}

@end
