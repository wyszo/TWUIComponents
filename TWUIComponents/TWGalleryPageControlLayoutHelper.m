//
//  TWUIComponents
//

#import "TWGalleryPageControlLayoutHelper.h"
#import <KZAsserts.h>


@implementation TWGalleryPageControlLayoutHelper

- (void)installConstraintsOnPageControl:(UIPageControl *)pageControl forScrollView:(UIScrollView *)scrollView withBottomOffset:(CGFloat)bottomOffset

{
  AssertTrueOrReturn(pageControl);
  AssertTrueOrReturn(scrollView);
  
  pageControl.translatesAutoresizingMaskIntoConstraints = NO; // because we're building layout from code
  
  [self pinPageControl:pageControl toScrollViewBottom:(UIScrollView *)scrollView withOffset:bottomOffset];
  [self centerPageControlHorizontally:pageControl inView:scrollView];
}

- (void)pinPageControl:(UIPageControl *)pageControl toScrollViewBottom:(UIScrollView *)scrollView withOffset:(CGFloat)offset
{
  AssertTrueOrReturn(pageControl);
  AssertTrueOrReturn(scrollView);
  
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:pageControl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:offset];
  [scrollView.superview addConstraint:constraint];
}

- (void)centerPageControlHorizontally:(UIPageControl *)pageControl inView:(UIView *)view
{
  AssertTrueOrReturn(pageControl);
  AssertTrueOrReturn(view);
  
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(<=1)-[pageControl]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(view, pageControl)];
  [view.superview addConstraints:constraints];
}

@end
